# Usage: place in desired folder then run like so:
#	    ruby word_frequency.rb [number of contiguous words] [desired file extension]
#	    ruby word_frequency.rb 1 vb	    #list of most frequent single words in all *.vb files in current directory and subdirectories
#	    ruby word_frequency.rb	    #same as above, the defaults are '1' and 'vb'
#	    ruby word_frequency.rb 5 cs	    #list of the most frequent 5-word phrases in all *.cs files in current directory and subdirectories
# Depending on the encoding of the files you want to analyze, you might have to
# set the external encoding when you run this script, like so:
#           ruby -E 'iso-8859-1' word_frequency.rb 3
# I'm positive there's a better way for my scripts to handle this, but I don't
# know what it is yet.

$files_processed = 0
$ext = ".vb"
$wordsInPhrase = ARGV[0].to_i
$wordsInPhrase = 1 if $wordsInPhrase < 1
$optionalFileExtension = ARGV[1]
$ext = "."+$optionalFileExtension if $optionalFileExtension

def transformWordArrayToPhrases(words)
    phrases = Array.new
    (0..words.length - $wordsInPhrase).each {|i|
	phrases[i] = ""
	(0..$wordsInPhrase-1).each {|j|
	    phrases[i] += words[i+j] + " "
	}
    }
    return phrases
end

def forEachVbFile(directory, masterWordlist)
    currentDirectory = Dir.new(directory)

    Dir.glob(currentDirectory.path + "/*#{$ext}") { |filename|
	$files_processed += 1
	newWordlist = createWordFrequencyList(filename)
	newWordlist.each {|key, value|
	    if(masterWordlist[key])
		masterWordlist[key] = masterWordlist[key] + newWordlist[key]
	    else
		masterWordlist[key] = newWordlist[key]
	    end
	}
    }

    Dir.glob(currentDirectory.path + "/**") { |dirname|
	if File.directory? dirname
	    forEachVbFile(dirname, masterWordlist)
	end
    }
end

def createWordFrequencyList(filename)
    wordlist = Hash.new
    File.open(filename, 'r') { |f|
	f.each_line { |line|
	    words = transformWordArrayToPhrases(line.split)
	    words.each {|word|
		if(wordlist[word])
		    wordlist[word] = wordlist[word] + 1
		else
		    wordlist[word] = 1
		end
	    }
	}
    }
    return wordlist
end


Dir.mkdir "wordfreq" unless Dir.exists? "wordfreq"
currentDirectoryName = File.basename(Dir.pwd)
reportFileName = "wordfreq/#{currentDirectoryName}-#{"%02d" % $wordsInPhrase}words#{$ext}.wordfreq"

puts "Processing #{Dir.pwd}..."
masterWordlist = Hash.new
forEachVbFile(".", masterWordlist)
puts "Files processed: #{$files_processed}"

File.open(reportFileName, "w+") { |reportfile|
    reportfile.puts "Word Frequency List:\n"
    masterWordlist
	.to_a
	.reject {|key, value| value == 1 }
	.sort {|a,b| b[1] <=> a[1] }
	.each {|key, value| reportfile.puts "#{value}".rjust(7) + ": #{key}"
    }
}

puts "Report file saved as: #{reportFileName}"
