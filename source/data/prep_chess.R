# Builds data/chess_clean.csv for chess_uncertainty_starter.qmd.
# Keeps decisive games with rating gap <= 500, then stacks two rows per game
# (one from each player's perspective).
library(tidyverse)

chess <- read_csv("https://raw.githubusercontent.com/rfordatascience/tidytuesday/main/data/2024/2024-10-01/chess.csv") |>
    filter(winner != "draw") |>
    mutate(
        game_id = row_number(),
        gap = white_rating - black_rating,
        white_wins = winner == "white"
    ) |>
    filter(abs(gap) <= 500)

chess_clean <- bind_rows(
    chess |> mutate(first_mover = "White", win = white_wins),
    chess |> mutate(first_mover = "Black", gap = -gap, win = !white_wins)
) |>
    mutate(win = as.integer(win)) |>
    select(game_id, first_mover, gap, win) |>
    arrange(game_id)

write_csv(chess_clean, "data/chess_clean.csv")
