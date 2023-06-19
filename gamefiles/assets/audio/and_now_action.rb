# This track was made using random notes.  A direct recreation with this Code is likely impossible.

# Dieser Track wurde mit zufälligen Noten erstellt. Eine direkte Rekreation mithilfe dieses Codes ist nahezu unmöglich.

60.times do
  with_fx :octaver, amp: 2, subsub_amp: 0  do
    use_synth :chiplead
    notes1 = (scale :f3, :melodic_minor_desc, num_octaves: 2)
    notes2 = (scale :f2, :melodic_minor_desc, num_octaves: 2)
    12.times do
      play notes1.choose, release: 0.1
      sleep 0.15
    end
    4.times do
      play notes2.choose, release: 0.1
      sleep 0.15
    end
  end
end