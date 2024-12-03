{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  env.AOC_DAY = "3";
  env.AOC_PART = "1";

  packages = with pkgs; [
    git
    nixfmt-rfc-style
    aoc-cli
    ghcid
    ormolu

    (ghc.withPackages (
      p: with p; [
        parsec
        containers
      ]
    ))
  ];

  dotenv.enable = true;

  languages.haskell.enable = true;

  processes = {
    "aoc2024:download".exec = "aoc download --day $AOC_DAY --overwrite";
    "aoc2024:dev".exec = "ghcid -c 'ghci -Wall' -T main src/Main.hs";
  };

  tasks = {
    "aoc2024:download".exec = "aoc download --day $AOC_DAY --overwrite";
    "aoc2024:compile".exec = "ghc -isrc/ src/Main.hs -o ./aoc2024";
    "aoc2024:guess" = {
      exec = "./aoc2024 > guess";
      after = [
        "aoc2024:download"
        "aoc2024:compile"
      ];
    };
    "aoc2024:submit" = {
      exec = ''
        GUESS=$(cat guess)
        echo "Day $AOC_DAY Part $AOC_PART Guess $GUESS"
        SUBMIT_LOG=$(aoc submit -d $AOC_DAY $AOC_PART $GUESS)
        echo $SUBMIT_LOG
        echo $SUBMIT_LOG | grep -q "That's the right answer!"
      '';
      after = [ "aoc2024:guess" ];
    };
    "aoc2024:all" = {
      exec = "git add . && git commit -m \"Day $AOC_DAY part $AOC_PART\"";
      after = [ "aoc2024:submit" ];
    };
  };
}
