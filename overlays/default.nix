{
  config,
  pkgs,
  lib,
  ...
}:
{
  nixpkgs.overlays = [
    (final: prev: {
      plan9port = prev.symlinkJoin {
        name = "plan9port_wrapped";
        paths = [ prev.plan9port ];
        buildInputs = [ prev.makeWrapper ];
        # this feels bad
        # TODO test on linux
        # TODO move this to a module with configurable font
        postBuild = ''
          pwd
          echo $out

          mv $out/bin/9 $out/bin/.9
          substitute $out/bin/.9 $out/bin/9 \
            --replace-fail "${prev.plan9port}" "$out"
          chmod +x $out/bin/9

          wrapProgram $out/bin/9 \
            --set font /usr/local/plan9/font/lucm/unicode.9.font,/mnt/font/Menlo-Regular/25a/font

          wrapProgram $out/plan9/bin/acme \
            --add-flags "-f /lib/font/bit/lucsans/euro.8.font,/mnt/font/LucidaGrande/25a/font \
              -F /usr/local/plan9/font/pelm/unicode.9.font,/mnt/font/Menlo-Regular/25a/font"
        '';
      };
    })
  ];
}
