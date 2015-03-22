function __tilde_help
  echo "Unrecognized command."
  echo ""
  echo "Usage: tilde <COMMAND> [OPTIONS]"
end

function __tilde_ignore_patterns
  set -l tilde_dir $argv[1]
  set -l tilde_ignore_file $tilde_dir/.tildeignore

  if test -e $tilde_ignore_file
    paste -s -d" " (sed '/^[[:space:]]*$/d' $tilde_ignore_file | awk '{print " ! -name \""$0"\""}' | psub)
  else
    return
  end
end

function __tilde_linkable_files
  set -l dir $argv[1]
  set -l default_ignore_patterns '! -name ".git" ! -name ".tilde" ! -name ".tildeignore"'
  set -l dynamic_ignore_patterns (__tilde_ignore_patterns $dir)
  set -l search_patterns "-depth 1 \\( -name '*' $default_ignore_patterns $dynamic_ignore_patterns \\)"

  eval find $dir "$search_patterns"
end

function __tilde_clone
  echo $argv | read -l tilde_home original_repo_name local_repo_name

  if test -z $local_repo_name
    set local_repo_name (basename $original_repo_name)
  end

  set -l repo_url "git@github.com:$original_repo_name.git"
  git clone $repo_url $tilde_home/$local_repo_name
end

function __tilde_link
  echo $argv | read -l symlink_dir tilde_home repo_name

  set -l tilde_repo $tilde_home/$repo_name

  if not test -d $tilde_repo
    echo "No $tilde_repo directory found. Exiting."
    return
  end

  echo "Syncing $tilde_repo with $symlink_dir"
  echo ""

  for file in (__tilde_linkable_files $tilde_repo)
    set -l base_name (basename $file)
    set -l source_path $file
    set -l target_path $symlink_dir/$base_name

    if test -L $target_path
      echo "Skipped $source_path: Already exists as symbolic link"
    else if test -f $target_path
      echo "Skipped $source_path: Already exists as regular file"
    else
      echo "Symlinking $target_path to $source_path"
      ln -s $source_path $target_path
    end
  end
end

function tilde --description  "node-deja implemented in fish"

  # tilde default settings
  set -l symlink_dir $HOME
  set -l tilde_home $HOME/.deja

  if not test -d $tilde_home
    echo "No $tilde_home directory found. Exiting."
    return
  end

  if test \( (count $argv) -ge 4 -o  (count $argv) -lt 2 \)
    __tilde_help
    return
  end

  echo $argv | read -l subcommand argument_1 argument_2

  if test -z $argument_1
    __tilde_help
    return
  end

  switch $subcommand
    case "link"
      __tilde_link $symlink_dir $tilde_home $argument_1
    case "clone"
      __tilde_clone $tilde_home $argument_1 $argument_2
  end
end
