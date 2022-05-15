function input = get_input(transformer, data)
  %
  %
  % (C) Copyright 2022 Remi Gau

  assert(isstruct(transformer));
  assert(numel(transformer) == 1);

  if isfield(transformer, 'Input')

    input = transformer.Input;

    if isempty(input)
      input = {};
      if isfield(transformer, 'verbose')
        warning('empty "Input" field');
      end
      return
    end

  else
    input = {};
    return

  end

  if ~iscell(input)
    input = {input};
  end

  bids.transformers.check_field(input, data, 'Input');

end
