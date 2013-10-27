require 'ruby-mpd'

def update_dashboard(mpd)
  if mpd.current_song
    artist = "#{mpd.current_song.artist}"
    title = "#{mpd.current_song.title}"
    text = [artist, title].join(" – ")
  else
    text = "[empty playlist]"
  end
  text += "<br><small>Volume: #{mpd.volume}%</small><br>"
  send_event('mpd-status', { text: text })
end

SCHEDULER.in '0s' do
  mpd = MPD.new 'mpd.chaosdorf.dn42', 6600, {callbacks: true}
  mpd.connect
  update_dashboard(mpd)
  mpd.on :volume do |volume|
    update_dashboard(mpd)
  end
  mpd.on :song do |song|
    update_dashboard(mpd)
  end
end

