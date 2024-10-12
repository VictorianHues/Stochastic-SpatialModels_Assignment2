{
  description = "Flake used for computational science.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      # ndlib = 
      #   let
      #     pname = "ndlib";
      #     version = "5.1.1";
      #   in
      #   pkgs.python312Packages.buildPythonPackage {
      #     inherit pname version;
      #     src = pkgs.fetchPypi {
      #       inherit pname version;
      #       sha256 = "sha256-qKss56484vQRZHbaan0ks0qLZKeK8Wek99mGFTtJ/Dw=";
      #     };
      #     doCheck = false;
      #   };
    in
    {
      nixpkgs.overlays = [
        (self: super: {
          python312Packages = super.python312Packages.override {
            overrides = pyself: pysuper: {
              # lmfit = pysuper.lmfit.overrideAttrs {doCheck = false;};
            };
          };
        }
        )
      ];

      devShells.${system}.default = pkgs.mkShell {
        nativeBuildInputs = with pkgs; [
          python312Packages.python
          python312Packages.jupyter
          python312Packages.pandas
          python312Packages.polars
          python312Packages.matplotlib
          python312Packages.ipympl
          python312Packages.numpy
          python312Packages.alive-progress
          python312Packages.lmfit
          python312Packages.scipy
          python312Packages.networkx

          typst
        ];

      };

      doCheck = false;
    };
}
