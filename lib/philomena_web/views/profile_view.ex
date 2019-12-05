defmodule PhilomenaWeb.ProfileView do
  use PhilomenaWeb, :view

  def award_order(awards) do
    awards
    |> Enum.sort_by(&{!&1.badge.priority, &1.awarded_on})
  end

  def badge_image(badge, options \\ []) do
    img_tag(badge_url_root() <> "/" <> badge.image, options)
  end

  def award_title(%{badge_name: nil} = award),
    do: award.badge.title
  def award_title(%{badge_name: ""} = award),
    do: award.badge.title
  def award_title(award),
    do: award.badge_name

  def sparkline_data(data) do
    # Normalize range
    {min, max} = Enum.min_max(data)
    max = max(max, 0)
    min = max(min, 0)

    content_tag :svg, [width: "100%", preserveAspectRatio: "none", viewBox: "0 0 90 20"] do
      for {val, i} <- Enum.with_index(data) do
        # Filter out negative values
        calc = max(val, 0)

        # Lerp or 0 if not present
        height = zero_div((calc - min) * 20, max - min)

        # In SVG coords, y grows down
        y = 20 - height

        content_tag :rect, [class: "barline__bar", x: i, y: y, width: 1, height: height] do
          content_tag :title, val
        end
      end
    end
  end

  defp zero_div(_num, 0), do: 0
  defp zero_div(num, den), do: div(num, den)

  defp badge_url_root do
    Application.get_env(:philomena, :badge_url_root)
  end
end