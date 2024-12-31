function hyprlog --wraps=watch\ -n\ 0.1\ \"grep\ -v\ \\\"arranged\\\"\ \$XDG_RUNTIME_DIR/hypr/\$HYPRLAND_INSTANCE_SIGNATURE/hyprland.log\ \|\ tail\ -n\ 40\" --description alias\ hyprlog=watch\ -n\ 0.1\ \"grep\ -v\ \\\"arranged\\\"\ \$XDG_RUNTIME_DIR/hypr/\$HYPRLAND_INSTANCE_SIGNATURE/hyprland.log\ \|\ tail\ -n\ 40\"
  watch -n 0.1 "grep -v \"arranged\" $XDG_RUNTIME_DIR/hypr/$HYPRLAND_INSTANCE_SIGNATURE/hyprland.log | tail -n 40" $argv
        
end
