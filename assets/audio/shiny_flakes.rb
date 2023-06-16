# This track was made using random notes.  A direct recreation with this Code is likely impossible.

# Dieser Track wurde mit zufälligen Noten erstellt. Eine direkte Rekreation mithilfe dieses Codes ist nahezu unmöglich.

live_loop :a do
  with_fx :reverb, room: 0.9 do
    use_synth :chiplead
    notes = (scale :E2, :major, num_octaves: 3)
    
    8.times do
      play notes.choose, release: 0.1, cutoff: rrand(50, 100)
      sleep 0.1
    end
    4.times do
      play notes.choose, release: 0.2, cutoff: rrand(100, 150)
      sleep 0.2
    end
    8.times do
      play notes.choose, release: 0.1, cutoff: rrand(50, 150)
      sleep 0.1
    end
  end
end