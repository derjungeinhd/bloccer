use_synth :chiplead

with_fx :reverb, room: 0.5 do
  with_fx :echo, phase: 0.1, decay: 0.4 do
    play chord(56, :major), release: 0.1
  end
end