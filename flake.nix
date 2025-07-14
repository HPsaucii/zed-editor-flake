{
  description = "A flake providing an up-to-date package for zed-editor";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {
    flake-parts,
    nixpkgs,
    ...
  }:
    flake-parts.lib.mkFlake {inherit inputs;} (
      {
        withSystem,
        moduleWithSystem,
        flake-parts-lib,
        ...
      }: {
        systems = with nixpkgs.lib.platforms; linux ++ darwin;

        perSystem = {
          system,
          pkgs,
          self',
          inputs',
          ...
        }: {
          packages = {
            zed-editor = pkgs.callPackage ./packages/zed-editor {};
            zed-editor-fhs = self'.packages.zed-editor.passthru.fhs;

            zed-editor-preview = pkgs.callPackage ./packages/zed-editor-preview {};
            zed-editor-preview-fhs = self'.packages.zed-editor-preview.passthru.fhs;

            zed-editor-bin = pkgs.callPackage ./packages/zed-editor-bin {};
            zed-editor-bin-fhs = self'.packages.zed-editor-bin.passthru.fhs;

            zed-editor-preview-bin = pkgs.callPackage ./packages/zed-editor-preview-bin {};
            zed-editor-preview-bin-fhs = self'.packages.zed-editor-preview-bin.passthru.fhs;

            default = self'.packages.zed-editor;
          };

          apps = {
            zed-editor.program = "${self'.packages.zed-editor}/bin/zeditor";
            zed-editor-fhs.program = "${self'.packages.zed-editor-fhs}/bin/zeditor";
            zed-editor-preview.program = "${self'.packages.zed-editor-preview}/bin/zeditor";
            zed-editor-preview-fhs.program = "${self'.packages.zed-editor-preview-fhs}/bin/zeditor";
            zed-editor-bin.program = "${self'.packages.zed-editor-bin}/bin/zeditor";
            zed-editor-bin-fhs.program = "${self'.packages.zed-editor-bin-fhs}/bin/zeditor";
            zed-editor-preview-bin.program = "${self'.packages.zed-editor-preview-bin}/bin/zeditor";
            zed-editor-preview-bin-fhs.program = "${self'.packages.zed-editor-preview-bin-fhs}/bin/zeditor";
          };
        };
      }
    );
}
