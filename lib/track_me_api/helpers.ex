defmodule TrackMeApi.Helpers do
  def to_local_date(datetime, timezone \\ "Africa/Kampala") do
    datetime
    |> DateTime.shift_zone!(timezone)
    |> Calendar.strftime("%d-%m-%Y %H:%M:%S")
  end
end
