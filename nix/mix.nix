{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    exsync = buildMix rec {
      name = "exsync";
      version = "0.2.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "15h8x398jwag80l9gf5q8r9pmpxgj5py8sh6m9ry9fwap65jsqpp";
      };

      beamDeps = [ file_system ];
    };

    file_system = buildMix rec {
      name = "file_system";
      version = "0.2.10";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1p0myxmnjjds8bbg69dd6fvhk8q3n7lb78zd4qvmjajnzgdmw6a1";
      };

      beamDeps = [];
    };
  };
in self

