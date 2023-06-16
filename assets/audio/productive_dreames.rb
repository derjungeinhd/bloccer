# This track was made using random notes. It was made only through changing the num_octaves parameter in a range of 2 to 4. A direct recreation with this Code is likely impossible.

# Dieser Track wurde mit zufälligen Noten erstellt. Einzig der num_octaves Parameter wurde in einer Scala von 2-4 innerhalb des Songs verändert. Eine direkte Rekreation mithilfe dieses Codes ist nahezu unmöglich.

live_loop :a do
  with_fx :reverb do
    use_synth :chipbass
    notes = (scale :D2, :minor_pentatonic, num_octaves: 3)
    
    8.times do
      play notes.choose, release: 0.5, cutoff: rrand(70, 120)
      sleep 0.5
    end
    2.times do
      play notes.choose, release: 1, cutoff: rrand(60, 150)
      sleep 1
    end
  end
end