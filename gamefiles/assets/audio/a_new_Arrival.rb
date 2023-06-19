# This track was made using random notes. It was made only through changing the num_octaves parameter in a range of 2 to 4. A direct recreation with this Code is likely impossible.

# Dieser Track wurde mit zufälligen Noten erstellt. Einzig der num_octaves Parameter wurde in einer Scala von 2-4 innerhalb des Songs verändert. Eine direkte Rekreation mithilfe dieses Codes ist nahezu unmöglich.

live_loop :a do
  use_synth :chiplead
  notes = (scale :C2, :minor, num_octaves: 2)
  16.times do
    play notes.choose, release: 0.1, cutoff: rrand(40, 170)
    sleep 0.2
  end
end
