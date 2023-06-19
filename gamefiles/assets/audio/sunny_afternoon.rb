loop do
  with_fx :reverb, room: 0.7 do
    use_synth :chiplead
    3.times do
      play 48, release: 0.1
      sleep 0.3
      play 41, release: 0.1
      sleep 0.3
      play 77, release: 0.1
      sleep 0.3
      play 72, release: 0.1
      sleep 0.3
      play 41, release: 0.1
      sleep 0.3
      play 77, release: 0.1
      sleep 0.3
      
      play 46, release: 0.1
      sleep 0.3
      play 65, release: 0.1
      sleep 0.3
      play 77, release: 0.1
      sleep 0.3
      play 69, release: 0.1
      sleep 0.3
      
      play 67, release: 0.1
      sleep 0.3
      play 48, release: 0.1
      sleep 0.3
      play 43, release: 0.1
      sleep 0.3
      play 57, release: 0.1
      sleep 0.3
      
      play 65, release: 0.2
      sleep 0.3
      play 60, release: 0.2
      sleep 0.3
      play 50, release: 0.2
      sleep 0.3
      
      play 43, release: 0.2
      sleep 0.3
      play 46, release: 0.2
      sleep 0.3
      play 41, release: 0.2
      sleep 0.3
      play 60, release: 0.2
      sleep 0.3
      
      
      
      play 65, release: 0.3
      sleep 0.3
      play 57, release: 0.3
      sleep 0.3
      play 57, release: 0.3
      sleep 0.3
      play 58, release: 0.3
      sleep 0.3
      
      play 67, release: 0.3
      sleep 0.3
      play 58, release: 0.6
      sleep 0.6
      
      play 58, release: 0.3
      sleep 0.3
      play 63, release: 0.3
      sleep 0.3
      play 55, release: 0.3
      sleep 0.3
      play 55, release: 0.3
      sleep 0.3
      play 56, release: 0.3
      sleep 0.3
      
      play 65, release: 0.3
      sleep 0.3
    end
    
    play 48, release: 0.1
    sleep 0.3
    play 41, release: 0.1
    sleep 0.3
    play 77, release: 0.1
    sleep 0.3
    play 72, release: 0.1
    sleep 0.3
    play 41, release: 0.1
    sleep 0.3
    play 77, release: 0.1
    sleep 0.3
    
    play 46, release: 0.1
    sleep 0.3
    play 65, release: 0.1
    sleep 0.3
    play 77, release: 0.1
    sleep 0.3
    play 69, release: 0.1
    sleep 0.3
    
    play 67, release: 0.1
    sleep 0.3
    play 48, release: 0.1
    sleep 0.3
    play 43, release: 0.1
    sleep 0.3
    play 57, release: 0.1
    sleep 0.3
    
    play 65, release: 0.2
    sleep 0.3
    play 60, release: 0.2
    sleep 0.3
    play 50, release: 0.2
    sleep 0.3
    
    play 43, release: 0.2
    sleep 0.3
    play 46, release: 0.2
    sleep 0.3
    play 41, release: 0.2
    sleep 0.3
    play 60, release: 0.2
    sleep 0.3
    
    
    
    play 65, release: 0.3
    sleep 0.3
    play 57, release: 0.3
    sleep 0.3
    play 57, release: 0.3
    sleep 0.3
    play 58, release: 0.3
    sleep 0.3
    
    play 67, release: 0.3
    sleep 0.3
    play 58, release: 0.6
    sleep 0.6
    
    in_thread do
      use_synth :chipbass
      
      play 58, release: 0.3
      sleep 0.3
      play 63, release: 0.3
      sleep 0.3
      play 55, release: 0.3
      sleep 0.3
      play 55, release: 0.3
      sleep 0.3
      play 56, release: 0.3
      sleep 0.3
      
      play 65, release: 0.3
      sleep 0.3
    end
    
    play 58, release: 0.3
    sleep 0.3
    play 63, release: 0.3
    sleep 0.3
    play 55, release: 0.3
    sleep 0.3
    play 55, release: 0.3
    sleep 0.3
    play 56, release: 0.3
    sleep 0.3
    
    play 65, release: 0.3
    sleep 0.3
    
    3.times do
      play 48, release: 0.1
      sleep 0.3
      play 41, release: 0.1
      sleep 0.3
      play 77, release: 0.1
      sleep 0.3
      play 72, release: 0.1
      sleep 0.3
      play 41, release: 0.1
      sleep 0.3
      play 77, release: 0.1
      sleep 0.3
      
      play 46, release: 0.1
      sleep 0.3
      play 65, release: 0.1
      sleep 0.3
      play 77, release: 0.1
      sleep 0.3
      play 69, release: 0.1
      sleep 0.3
      
      play 67, release: 0.1
      sleep 0.3
      play 48, release: 0.1
      sleep 0.3
      play 43, release: 0.1
      sleep 0.3
      play 57, release: 0.1
      sleep 0.3
      
      play 65, release: 0.2
      sleep 0.3
      play 60, release: 0.2
      sleep 0.3
      play 50, release: 0.2
      sleep 0.3
      
      play 43, release: 0.2
      sleep 0.3
      play 46, release: 0.2
      sleep 0.3
      play 41, release: 0.2
      sleep 0.3
      play 60, release: 0.2
      sleep 0.3
      
      
      
      play 65, release: 0.3
      sleep 0.3
      play 57, release: 0.3
      sleep 0.3
      play 57, release: 0.3
      sleep 0.3
      play 58, release: 0.3
      sleep 0.3
      
      play 67, release: 0.3
      sleep 0.3
      play 58, release: 0.6
      sleep 0.6
      
      play 58, release: 0.3
      sleep 0.3
      play 63, release: 0.3
      sleep 0.3
      play 55, release: 0.3
      sleep 0.3
      play 55, release: 0.3
      sleep 0.3
      play 56, release: 0.3
      sleep 0.3
      
      play 65, release: 0.3
      sleep 0.3
    end
    use_synth :chipbass
    
    play 48, release: 0.1
    sleep 0.3
    play 41, release: 0.1
    sleep 0.3
    play 77, release: 0.1
    sleep 0.3
    play 72, release: 0.1
    sleep 0.3
    play 41, release: 0.1
    sleep 0.3
    play 77, release: 0.1
    sleep 0.3
    
    play 46, release: 0.1
    sleep 0.3
    play 65, release: 0.1
    sleep 0.3
    play 77, release: 0.1
    sleep 0.3
    play 69, release: 0.1
    sleep 0.3
    
    play 67, release: 0.1
    sleep 0.3
    play 48, release: 0.1
    sleep 0.3
    play 43, release: 0.1
    sleep 0.3
    play 57, release: 0.1
    sleep 0.3
    
    play 65, release: 0.2
    sleep 0.3
    play 60, release: 0.2
    sleep 0.3
    play 50, release: 0.2
    sleep 0.3
    
    play 43, release: 0.2
    sleep 0.3
    play 46, release: 0.2
    sleep 0.3
    play 41, release: 0.2
    sleep 0.3
    play 60, release: 0.2
    sleep 0.3
    
    
    
    play 65, release: 0.3
    sleep 0.3
    play 57, release: 0.3
    sleep 0.3
    play 57, release: 0.3
    sleep 0.3
    play 58, release: 0.3
    sleep 0.3
    
    play 67, release: 0.3
    sleep 0.3
    play 58, release: 0.6
    sleep 0.6
    
    play 58, release: 0.3
    sleep 0.3
    play 63, release: 0.3
    sleep 0.3
    play 55, release: 0.3
    sleep 0.3
    play 55, release: 0.3
    sleep 0.3
    play 56, release: 0.3
    sleep 0.3
    
    play 65, release: 0.3
    sleep 0.3
  end
end