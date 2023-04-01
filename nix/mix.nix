{ lib, beamPackages, overrides ? (x: y: {}) }:

let
  buildRebar3 = lib.makeOverridable beamPackages.buildRebar3;
  buildMix = lib.makeOverridable beamPackages.buildMix;
  buildErlangMk = lib.makeOverridable beamPackages.buildErlangMk;

  self = packages // (overrides self packages);

  packages = with beamPackages; with self; {
    bunt = buildMix rec {
      name = "bunt";
      version = "0.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "19bp6xh052ql3ha0v3r8999cvja5d2p6cph02mxphfaj4jsbyc53";
      };

      beamDeps = [];
    };

    certifi = buildRebar3 rec {
      name = "certifi";
      version = "2.11.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1dwv7igavn21jwm0mi28mizpk5f01n8b6d07kahvmyn35raf0dwy";
      };

      beamDeps = [];
    };

    chacha20 = buildMix rec {
      name = "chacha20";
      version = "1.0.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0j93ph8j02lk6xw3kzn7kf0vimjscfq52zysy3qh76df479za9r0";
      };

      beamDeps = [];
    };

    remedy_cowlib = buildRebar3 rec {
      name = "remedy_cowlib";
      version = "2.11.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0c5ij4f6bihg05q0rrsj2q83x1y3aldinpr86ihwp070131ksq8b";
      };

      beamDeps = [];
    };

    credo = buildMix rec {
      name = "credo";
      version = "1.7.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1mv9lyw6hgjn6hlnzfbs0x2dchvwlmj8bg0a8l7iq38z7pvgqfb8";
      };

      beamDeps = [ bunt file_system jason ];
    };

    curve25519 = buildMix rec {
      name = "curve25519";
      version = "1.0.5";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0b8ryj7icn2x7b5nrvqd7yqpfawi3fwmzbn3bx6ls5gibgakmfhg";
      };

      beamDeps = [];
    };

    ed25519 = buildMix rec {
      name = "ed25519";
      version = "1.4.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1iqfr14gzf1gbkdwjcic4c9yxp6qz4swl68hx1482gda7x7vib0d";
      };

      beamDeps = [];
    };

    equivalex = buildMix rec {
      name = "equivalex";
      version = "1.0.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1z25w0h81irkflyxfyni188p53srs859q6s6dv9iflc5vcd33yj6";
      };

      beamDeps = [];
    };

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

    gen_stage = buildMix rec {
      name = "gen_stage";
      version = "1.2.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "00dh6n1jzw3gd77iyscgrsm51ajpdnpy7hbaz8prjnx0gxjvxs43";
      };

      beamDeps = [];
    };

    remedy_gun = buildRebar3 rec {
      name = "remedy_gun";
      version = "2.0.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0vj49hlh7c2dlddcs1bnnxjz7klgv2ry36w0hrzpaayizf2mls5n";
      };

      beamDeps = [ cowlib ];
    };

    jason = buildMix rec {
      name = "jason";
      version = "1.4.0";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0891p2yrg3ri04p302cxfww3fi16pvvw1kh4r91zg85jhl87k8vr";
      };

      beamDeps = [];
    };

    kcl = buildMix rec {
      name = "kcl";
      version = "1.4.2";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "01dzxbz1036zx2cdrb7np5ga289bm1j8a9abhgv2v42dhk9ks24z";
      };

      beamDeps = [ curve25519 ed25519 poly1305 salsa20 ];
    };

    mime = buildMix rec {
      name = "mime";
      version = "2.0.3";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0szzdfalafpawjrrwbrplhkgxjv8837mlxbkpbn5xlj4vgq0p8r7";
      };

      beamDeps = [];
    };

    nostrum = buildMix rec {
      name = "nostrum";
      version = "0.6.1";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0spp5c3l30pxslqsinvc0qizv9w7k26b7glgj9j6cxhkwi3mm4i7";
      };

      beamDeps = [ certifi gen_stage gun jason kcl mime ];
    };

    poly1305 = buildMix rec {
      name = "poly1305";
      version = "1.0.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "0fxwgp22jx9hb88vlnynb539smwk2r5dnf9ikca5w6d5c536hkp1";
      };

      beamDeps = [ chacha20 equivalex ];
    };

    salsa20 = buildMix rec {
      name = "salsa20";
      version = "1.0.4";

      src = fetchHex {
        pkg = "${name}";
        version = "${version}";
        sha256 = "1ilaqpynkcs1hkdf2d3qryi7jqhlsm4cxrv1znqdsqx5rzcdqpbl";
      };

      beamDeps = [];
    };
  };
in self

