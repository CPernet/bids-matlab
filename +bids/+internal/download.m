function filename = download(URL, output_dir, verbose)
  %
  % USAGE::
  %
  %   filename = download(URL, output_dir, verbose)
  %
  % (C) Copyright 2021 BIDS-MATLAB developers
  if nargin < 2
    output_dir = pwd;
  end

  msg = sprintf('Downloading dataset from:\n %s\n\n', URL);
  print_to_screen(msg, verbose);

  tokens = regexp(URL, '/', 'split');
  protocol = tokens{1};

  filename = tokens{end};

  if exist(filename, 'file')
    delete(filename);
  end

  if strcmp(protocol, 'http:')

    if isunix()
      if verbose
        system(sprintf('wget %s', URL));
      else
        system(sprintf('wget -q %s', URL));
      end
    else
      urlwrite(URL, filename);
    end

    % move file in case it was not downloaded in the root dir
    if ~exist(fullfile(output_dir, filename), 'file')
      print_to_screen([filename ' --> ' output_dir], verbose);
      movefile(filename, fullfile(output_dir, filename));
    end
    filename = fullfile(output_dir, filename);

  else

    ftp_server = tokens{3};
    ftpobj = ftp(ftp_server);

    filename = strjoin(tokens(4:end), '/');
    filename = mget(ftpobj, filename, output_dir);

  end

  if iscell(filename)
    filename = filename{1};
  end

  print_to_screen(' Done\n\n', verbose);

end

function print_to_screen(msg, verbose)
  if verbose
    fprintf(1, msg);
  end
end
