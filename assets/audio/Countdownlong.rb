use_synth :chipbass

in_thread do
  use_synth :chiplead
  
  play 70, release: 0.3
  sleep 0.7
  play 70, release: 0.3
  sleep 0.7
  play 70, release: 0.3
  sleep 0.7
  play 80, release: 0.5
end

play 70, release: 0.3
sleep 0.7
play 70, release: 0.3
sleep 0.7
play 70, release: 0.3