
# Exercise ----------------------------------------------------------------

# 1. Take a data set of your choice and create an ugly / not useful plot (we vote in the end)

# Making plots better -----------------------------------------------------

# Relies heavily on 
# https://cararthompson.github.io/rl-cambridge-beautifully-annotated/beautifully-annotated_RLadiesCam.html#/title-slide

penguins_skim <- (skim(penguins))

penguins_skim |> 
  View()

penguins |>
  drop_na(sex) |>
  ggplot(aes(species, fill = sex)) +
  geom_bar()

penguins |>
  drop_na(sex) |>
  group_by(species, sex) |>
  summarise(mean_weight = mean(body_mass_g, na.rm = T)) |>
  ggplot(aes(species, mean_weight, fill = sex)) +
  geom_bar(stat = "identity")

penguins |>
  drop_na(sex) |>
  group_by(species, sex) |>
  summarise(mean_weight = mean(body_mass_g, na.rm = T)) |>
  ggplot(aes(species, mean_weight, fill = sex)) +
  geom_col()

penguins |>
  drop_na(sex) |>
  group_by(species, sex) |>
  summarise(mean_weight = mean(body_mass_g, na.rm = T)) |>
  ggplot(aes(species, mean_weight, fill = sex)) +
  geom_col(position = "dodge")

penguins |>
  drop_na(sex) |>
  group_by(species, sex) |>
  summarise(mean_weight = mean(body_mass_g, na.rm = T)) |>
  ggplot(aes(species, mean_weight, fill = sex)) +
  geom_col(position = "dodge2")

penguins |>
  drop_na(sex) |>
  group_by(species, sex) |>
  summarise(mean_weight = mean(body_mass_g, na.rm = T)) |>
  ggplot(aes(species, mean_weight, fill = sex)) +
  geom_col(
    position = "dodge",
    col = "white",
    size = 1.5
  )

penguins |>
  drop_na(sex) |>
  group_by(species, sex) |>
  summarise(`Weight (μ)` = mean(body_mass_g, na.rm = T), .groups = "drop") |>
  mutate(
    Penguin = fct_reorder(species, `Weight (μ)`, .desc = T),
    Sex = str_to_title(sex)
  ) |>
  ggplot(aes(Penguin, `Weight (μ)`, fill = Sex)) +
  geom_col(
    position = "dodge",
    col = "white",
    size = 1.5
  ) +
  theme_minimal()

first_plot <- last_plot() +
  labs(
    title = "The average weight of Adelie and Chinstrap penguins is similar. In the sample Adelie had heavier males, while Chinstrap had heavier female.",
    subtitle = "Gentoo is the heaviest penguin species on the Palmer Archipelago."
  )  +
  facet_wrap(~Sex, ncol = 1)

first_plot

# picking colours ---------------------------------------------------------

# https://imagecolorpicker.com

generate_palette("#3c8c8c", n_colors = 3, blend_colour = "#eb7754", view_palette = T)
generate_palette("#0C1509", "go_lighter", n_colours = 6, view_palette = T)

penguins_palette <- c(
  "Male" = "#3c8c8c",
  "Female" = "#C87B5F",
  light_text = "#323A30",
  dark_text = "#0C1509"
)

view_palette(penguins_palette)


# also scales -------------------------------------------------------------

kgs <- function(x) {
  number_format(
    accuracy = 1,
    scale = 1 / 1000,
    suffix = "kg"
  )(x)
}

new_plot <- penguins |>
  drop_na(sex) |>
  group_by(species, sex) |>
  summarise(`Weight (μ)` = mean(body_mass_g, na.rm = T), .groups = "drop") |>
  mutate(
    Penguin = fct_reorder(species, `Weight (μ)`, .desc = T),
    Sex = str_to_title(sex)
  ) |>
  ggplot(aes(Penguin, `Weight (μ)`, fill = Sex, alpha = `Weight (μ)`)) +
  geom_col(
    position = "dodge",
    col = "white",
    size = 1.5,
    show.legend = F
  ) +
  labs(
    title = "The average weight of Adelie and Chinstrap penguins is similar. In the sample Adelie had heavier males, while Chinstrap had heavier female.",
    subtitle = "Gentoo is the heaviest penguin species on the Palmer Archipelago."
  ) +
  scale_fill_manual(values = penguins_palette) +
  scale_y_continuous(labels = kgs, breaks = c(1000, 3000, 5000)) +
  scale_alpha(range = c(.33, 1)) +
  coord_flip() +
  facet_wrap(~Sex, ncol = 1) +
  theme_minimal(base_size = 12) +
  theme(legend.position = "none")

new_plot
first_plot

# Text --------------------------------------------------------------------

list_of_fonts <- as_tibble(font_files())

font_add_google(name = "Spectral", family = "Spectral")
font_add_google(name = "Enriqueta", family = "Enriqueta")

showtext_auto()

new_plot +
  theme(legend.position = "none",
        text = element_text(colour = penguins_palette["light_text"],
                            family = "Spectral"),
        plot.title = element_text(colour = penguins_palette["dark_text"], 
                                  size = rel(1.5), 
                                  face = "bold",
                                  family = "Enriqueta"),
        strip.text = element_text(family = "Enriqueta",
                                  colour = penguins_palette["light_text"], 
                                  size = rel(1.1), face = "bold"),
        axis.text = element_text(colour = penguins_palette["light_text"]))


# title

new_plot +
  theme(legend.position = "none",
        text = element_text(colour = penguins_palette["light_text"],
                            family = "Spectral"),
        axis.title.y = element_blank(),
        plot.title = ggtext::element_textbox_simple(
          colour = penguins_palette["dark_text"], 
          size = rel(1.5), 
          face = "bold",
          family = "Enriqueta",
          lineheight = 1.3,
          margin = margin(0.5, 0, 1, 0, "lines")),
        plot.subtitle = ggtext::element_textbox_simple(
          size = rel(1.1), 
          lineheight = 1.3,
          margin = margin(0, 0, 1, 0, "lines")),
        strip.text = element_text(family = "Enriqueta",
                                  colour = penguins_palette["light_text"],
                                  size = rel(1.1), face = "bold",
                                  margin = margin(2, 0, 0.5, 0, "lines")),
        axis.text = element_text(colour = penguins_palette["light_text"]))

# title styling

themed_plot <- new_plot +
  labs(
    title = str_c(
      "The average weight of Adelie and Chinstrap penguins is similar. In the sample Adelie had heavier **<span style='color:",
      penguins_palette["Male"],
      "'>males</span>**, while Chinstrap had heavier **<span style='color:",
      penguins_palette["Female"],
      "'>females</span>**."
    ),
    subtitle = "**Gentoo** is the **heaviest** penguin species on the Palmer Archipelago."
  )  +
  theme(legend.position = "none",
        text = element_text(colour = penguins_palette["light_text"],
                            family = "Spectral"),
        axis.title.y = element_blank(),
        plot.title = ggtext::element_textbox_simple(
          colour = penguins_palette["dark_text"], 
          size = rel(1.5), 
          family = "Enriqueta",
          lineheight = 1.3,
          margin = margin(0.5, 0, 1, 0, "lines")),
        plot.subtitle = ggtext::element_textbox_simple(
          size = rel(1.1), 
          lineheight = 1.3,
          margin = margin(0, 0, 1, 0, "lines")),
        strip.text = element_text(family = "Enriqueta",
                                  colour = penguins_palette["light_text"],
                                  size = rel(1.1), face = "bold",
                                  margin = margin(2, 0, 0.5, 0, "lines")),
        axis.text = element_text(colour = penguins_palette["light_text"]))

first_plot
new_plot
themed_plot


# eye moevment -------------------------------------------------------------

finished_plot <- themed_plot +
  theme(strip.text = element_text(family = "Enriqueta",
                                  colour = penguins_palette["light_text"],
                                  size = rel(1.1), face = "bold",
                                  hjust = 0.03,
                                  margin = margin(2, 0, 0.5, 0, "lines"))) +
  ggtext::geom_textbox(aes(
    label = paste0("<span style=font-size:10pt>", 
                   species, "</span><br>", 
                   round(`Weight (μ)` / 1000, digits = 2), "kg")
  ),
  alpha = 1,
  size = 3,
  halign = 1, 
  hjust = 1,
  fill = NA,
  box.colour = NA,
  family = "Spectral",
  colour = "#FFFFFF"
  ) +
  scale_y_continuous(labels = kgs, breaks = c(1000, 3000, 5000), expand = c(0, 0.5))

finished_plot




first_plot
new_plot
themed_plot
finished_plot


# Exercise ----------------------------------------------------------------

# 1. Take a data set of your choice and create a beautiful plot (we vote in the end)

