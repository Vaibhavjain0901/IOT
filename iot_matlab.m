d = thingSpeakFetch(113405,'FFYI1CUQGOGUES02')

ard.pinMode(13,'output');
if d>35
    ard.digitalWrite(13,1);
else
    ard.digitalWrite(13,0)
end