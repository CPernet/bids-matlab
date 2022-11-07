function output_filename = create_participants_tsv(varargin)
  %
  % Creates a simple participants tsv for a BIDS dataset.
  %
  %
  % USAGE::
  %
  %   output_filename = bids.util.create_participants_tsv(layout_or_path);
  %
  %
  % :param layout_or_path:
  % :type  layout_or_path:  path or structure
  %
  %

  % (C) Copyright 2022 Remi Gau

  default_layout = pwd;
  default_tolerant = true;
  default_use_schema = true;
  default_verbose = false;

  is_dir_or_struct = @(x) (isstruct(x) || isdir(x));

  args = inputParser();

  addOptional(args, 'layout_or_path', default_layout, is_dir_or_struct);
  addParameter(args, 'tolerant', default_tolerant);
  addParameter(args, 'use_schema', default_use_schema);
  addParameter(args, 'verbose', default_verbose);

  parse(args, varargin{:});

  layout_or_path = args.Results.layout_or_path;
  tolerant = args.Results.tolerant;
  use_schema = args.Results.use_schema;
  verbose = args.Results.verbose;

  %%

  layout = bids.layout(layout_or_path, 'use_schema', use_schema);

  if ~isempty(layout.participants)
    msg = sprintf(['"participant.tsv" already exist for the following dataset.', ...
                   'Will not overwrite.\n', ...
                   '\t%s'], layout.pth);
    bids.internal.error_handling(mfilename(), 'participantFileExist', msg, tolerant, verbose);
    return
  end

  subjects_list = bids.query(layout, 'subjects');

  subjects_list = [repmat('sub-', numel(subjects_list), 1), char(subjects_list')];

  output_structure = struct('participant_id', subjects_list);

  output_filename = fullfile(layout.pth, 'participants.tsv');

  bids.util.tsvwrite(fullfile(layout.pth, 'participants.tsv'), output_structure);

  if verbose
    fprintf(1, ['\nCreated "participants.tsv" in the dataset.', ...
                '\n\t%s\n', ...
                'Please add participant age, gender...\n', ...
                'See this section of the BIDS specification:\n\t%s\n'], ...
            layout.pth, ...
            bids.internal.url('participants'));
  end

end
