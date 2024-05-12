{
  description = "Apple PKL package for Nix";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    pkl-x86_64-linux = {
      flake = false;
      url = "https://github.com/apple/pkl/releases/download/0.25.3/pkl-linux-amd64";
    };
    pkl-aarch64-linux = {
      flake = false;
      url = "https://github.com/apple/pkl/releases/download/0.25.3/pkl-linux-aarch64";
    };
    pkl-x86_64-darwin = {
      flake = false;
      url = "https://github.com/apple/pkl/releases/download/0.25.3/pkl-macos-amd64";
    };
    pkl-aarch64-darwin = {
      flake = false;
      url = "https://github.com/apple/pkl/releases/download/0.25.3/pkl-macos-aarch64";
    };
    jpkl = {
      flake = false;
      url = "https://github.com/apple/pkl/releases/download/0.25.3/jpkl";
    };
  };

  outputs =
    {
      self,
      nixpkgs,
      pkl-aarch64-linux,
      pkl-x86_64-linux,
      pkl-aarch64-darwin,
      pkl-x86_64-darwin,
      jpkl,
    }@inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
        "aarch64-linux"
      ];
      forEachSupportedSystem =
        f: nixpkgs.lib.genAttrs supportedSystems (system: f { pkgs = import nixpkgs { inherit system; }; });
    in
    {
      formatter = forEachSupportedSystem ({ pkgs }: pkgs.nixfmt-rfc-style);
      packages = forEachSupportedSystem (
        { pkgs }:
        rec {
          default = pkl;
          pkl = pkgs.buildFHSEnv {
            name = "pkl";
            targetPkgs = pkgs: with pkgs; [ libz ];
            runScript = ''${
              pkgs.symlinkJoin {
                name = "pkl";
                paths = [ ];
                buildInputs = [ pkgs.makeWrapper ];
                postBuild = ''
                  mkdir $out/bin -p
                  cp ${inputs."pkl-${pkgs.system}".outPath} $out/bin/pkl
                  chmod +x $out/bin/pkl
                  wrapProgram $out/bin/pkl --prefix PATH : $out/bin
                '';
              }
            }/bin/pkl'';
          };
          jpkl = pkgs.buildFHSEnv {
            name = "jpkl";
            targetPkgs = pkgs: with pkgs; [ libz jre ];
            runScript = ''${
              pkgs.symlinkJoin {
                name = "pkl";
                paths = [ ];
                buildInputs = with pkgs; [ makeWrapper ];
                postBuild = ''
                  mkdir $out/bin -p
                  cp ${inputs.jpkl.outPath} $out/bin/jpkl
                  chmod +x $out/bin/jpkl
                  wrapProgram $out/bin/jpkl --prefix PATH : $out/bin
                '';
              }
            }/bin/jpkl'';
          };
        }
      );
    };
}
