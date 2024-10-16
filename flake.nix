{
  description = "Flake used for computational science.";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      netdispatch = 
        let
          pname = "netdispatch";
          version = "0.1.0";
        in
        pkgs.python312Packages.buildPythonPackage {
          inherit pname version;
          src = pkgs.fetchPypi {
            inherit pname version;
            sha256 = "sha256-7z8bXFhHJT7qeWLUU/FZBrEOG5QyzNcVeW4f3y5PnDU=";
          };
          doCheck = false;
        };
      ndlib = 
        let
          pname = "ndlib";
          version = "5.1.1";
        in
        pkgs.python312Packages.buildPythonPackage {
          inherit pname version;
          # src = pkgs.fetchPypi {
          #   inherit pname version;
          #   sha256 = "sha256-qKss56484vQRZHbaan0ks0qLZKeK8Wek99mGFTtJ/Dw=";
          # };
          src = pkgs.fetchFromGitHub {
            owner = "GiulioRossetti";
            repo = pname;
            rev = "5493bbb95131afebd9c8c52166bee3d058e7830d";
            hash = "sha256-c2PW0xK6PT1yfqJeXQ4Lfj0OWk3nnYI2SgLZMxCVXNE=";
          };
          dependencies = with pkgs.python312Packages; [
            future
            netdispatch
            tqdm
          ];
          doCheck = false;
        };
      networkx = 
        let
          pname = "networkx";
          version = "3.4.1";
        in
        pkgs.python312Packages.buildPythonPackage rec {
          inherit pname version;
          pyproject = true;

          # disabled = pkgs.pythonOlder "3.8";

          src = pkgs.fetchPypi {
            inherit pname version;
            hash = "sha256-+d9F6Ft49b0BCZPol7Tx/bJCwR4BWxAb2VHlwOKZgtg=";
          };

          nativeBuildInputs = with pkgs; [ python312Packages.setuptools ];

          optional-dependencies = {
            default = with pkgs; [
              python312Packages.numpy
              python312Packages.scipy
              python312Packages.matplotlib
              python312Packages.pandas
            ];
            extra = with pkgs; [
              python312Packages.lxml
              python312Packages.pygraphviz
              python312Packages.pydot
              python312Packages.sympy
            ];
          };

          nativeCheckInputs = with pkgs; [
            python312Packages.pytest-xdist
            python312Packages.pytestCheckHook
          ];

          disabledTests = [
            # No warnings of type (<class 'DeprecationWarning'>, <class 'PendingDeprecationWarning'>, <class 'FutureWarning'>) were emitted.
            "test_connected_raise"
          ];

          meta = {
            changelog = "https://github.com/networkx/networkx/blob/networkx-${version}/doc/release/release_${version}.rst";
            homepage = "https://networkx.github.io/";
            downloadPage = "https://github.com/networkx/networkx";
            description = "Library for the creation, manipulation, and study of the structure, dynamics, and functions of complex networks";
            license = pkgs.lib.licenses.bsd3;
          };
        };
    in
    {
      # nixpkgs.overlays = [
      #   (self: super: {
      #     python312Packages = super.python312Packages.override {
      #       overrides = pyself: pysuper: {
      #         # lmfit = pysuper.lmfit.overrideAttrs {doCheck = false;};
      #       };
      #     };
      #   }
      #   )
      # ];

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
          networkx
          ndlib

          ffmpeg
        ];

      };

      doCheck = false;
    };
}