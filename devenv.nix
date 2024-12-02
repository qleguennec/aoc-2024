{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  env.AOC_DAY = "1";

  packages = with pkgs; [
    git
    nixfmt-rfc-style
    aoc-cli
    ghcid
    ormolu

    (ghc.withPackages (p: with p; [ parsec ]))
  ];

  dotenv.enable = true;

  languages.haskell.enable = true;

  processes = {
    "aoc2024:download".exec = "aoc download --day $AOC_DAY --overwrite";
    "aoc2024:dev".exec = "ghcid -c 'ghci -Wall' -T main src/Main.hs";
  };

  tasks = {
    "aoc2024:compile".exec = "ghc -isrc/ src/Main.hs -o ./aoc2024";
    "aoc2024:submit-part-1" = {
      exec = "aoc submit 1 $(./aoc2024) --day $AOC_DAY";
      after = [ "aoc2024:compile" ];
    };
    "aoc2024:part-1" = {
      exec = "git add . && git commit -m \"Day $AOC_DAY part 1\"";
      after = [ "aoc2024:submit-part-1" ];
    };
  };
}
