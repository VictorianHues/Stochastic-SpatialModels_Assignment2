{
  description = "Flake used for computational science.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
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
