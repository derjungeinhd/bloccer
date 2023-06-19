use_synth :chiplead

with_fx :reverb, room: 0.5 do
  with_fx :echo, phase: 0.1, decay: 2 do
    play chord(70, :major), release: 0.8
  end
end