{
  writeShellScriptBin,
  inotify-tools,
}:

writeShellScriptBin "startvrc" ''
  # this is a wrapper script to help avoid EAC errors.

  # 1. change me
  steamapps=~/.local/share/Steam/steamapps
  watch_folder="$steamapps"/compatdata/438100/pfx/drive_c/users/steamuser/AppData/LocalLow/VRChat/VRChat

  # 2. add me to VRChat launch options:
  # /path/to/startvrc.sh %command%
  # (place any extra env vars before startvrc)

  # 3. launch vrc
  # special thanks: openglfreak

  do_taskset() {
    log=$(${inotify-tools}/bin/inotifywait --include '.*\.txt' --event create "$watch_folder" --format '%f')

    echo "Log: $watch_folder/$log"

    while ! pid=$(pgrep VRChat); do
      sleep 0.1
    done

    echo "Setting VRChat to dual-core..."
    taskset -pac 0,1 "$pid"

    tail -f "$watch_folder/$log" 2>/dev/null | sed -n '/EOS Login Succeeded/{p;q}'
    sleep 1

    echo "Setting VRChat to all cores..."
    taskset -pac "0-$(($(nproc) - 1))" "$pid"

    echo "Our work here is done."
  }

  LD_PRELOAD=''' do_taskset </dev/null &
  exec "$@"
''
