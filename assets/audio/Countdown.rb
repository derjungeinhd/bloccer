use_synth :chipbass

in_thread do
  use_synth :chiplead
  
  play 70, release: 0.1
  sleep 0.3
  play 70, release: 0.1
  sleep 0.3
  play 70, release: 0.1
  sleep 0.3
  play 80, release: 0.1
end

play 70, release: 0.1
sleep 0.3
play 70, release: 0.1
sleep 0.3
play 70, release: 0.1