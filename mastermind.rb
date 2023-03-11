require 'pry-byebug'

PROMPT_GAME_EXPLANATION = "This is a game of Mastermind!

You are going to choose between being the code BREAKER or the code MAKER.
The code MAKER be prompted to make the code, and the code BREAKER will be 
prompted to make a guess. You can choose to local play multiplayer, with 
a friend, or if you are the BREAKER, against the computer.

The code consists of 4 numbers, and the numbers have to be between 1 and 6.

If a guess contains a correct number at the correct location, you will be
shown a ' ■ ', without telling you WHICH number. If a guess contains the 
correct number, but at the wrong location, you will be shown a ' o ', wit-
-hout telling you WHICH number\n\n\n"

class Game
    def initialize
        puts PROMPT_GAME_EXPLANATION
        @board = Board.new
    end

    def play
        win = false

        local_multiplayer = prompt_local_multiplayer?
        first_player_breaker = prompt_first_player_breaker?

        breaker = Player.new(@board, true)
        master = Player.new(@board, false)

        if local_multiplayer
            master.make_code(prompt_code)
        else
            master.make_random_code()
        end

        while !win
            if first_player_breaker
                guess = prompt_breaker_guess
                win = breaker.make_guess(guess)
                if win == nil
                    break
                end
            end

            @board.display_board(win)
        end
    end

    def prompt_local_multiplayer?
        puts "Do you want to play against another player locally? (y/...)"
        answer = gets.chomp.downcase

        return (answer == "y" ? true : false)
    end

    def prompt_first_player_breaker?
        puts "Do you want to be the code BREAKER? (y/...)"
        answer = gets.chomp.downcase

        return (answer == "y" ? true : false)
    end

    def prompt_breaker_guess
        puts "Write your guess with 4 numbers, each between 1 and 6"
        guess = gets.chomp.split('')
        guess_within_rules = false
        
        while !guess_within_rules
            if guess.length != 4
                puts "You must guess with a 4-number code"
                guess = gets.chomp.split('')
                next
            end

            guess.each do |num|
                num = num.to_i
                if num > 6 || num < 1
                    puts "Your number must be between 1 and 6"
                    guess_within_rules = false
                    break 
                else
                    guess_within_rules = true
                end
            end
            
            unless guess_within_rules
                guess = gets.chomp.split('')
            end
        end
        
        guess.map(&:to_i)
    end
end

class Player
    attr_reader :code_breaker, :board
    attr_accessor :guess_counter
    
    def initialize(board, code_breaker)
        @board = board
        @code_breaker = code_breaker
        @guess_counter = 9
    end
    
    def make_code(code)
        if code_breaker
            return
        end
        
        board.code = code
    end

    def make_random_code
        if code_breaker
            return
        end
        
       code = Array.new(4) {rand(1..6)}
       make_code(code) 
    end
    
    def make_guess(code_guess)
        if guess_counter < 0
            puts "You lost! No more guesses left!"
            return
        end

        unless code_breaker
            return
        end

        board.board[guess_counter] = code_guess
        
        if code_guess == board.code
            puts "You won!"
            4.times {board.guesses[guess_counter] << "■"}
            return true
        else
            code_guess.each_with_index do |guess, i|
                if board.code.include?(guess)
                    if board.code.find_index(guess) == i
                        board.guesses[guess_counter] << "■"
                    else
                        board.guesses[guess_counter] << "o"
                    end
                    
                    board.guesses[guess_counter].sort!
                end
            end
            
            @guess_counter = @guess_counter - 1
        end 

        return false
    end
end

class Board
    attr_accessor :code, :board, :guesses
    
    def initialize
        @code = Array.new(4) {0}
        @board = Array.new(10) {Array.new(4) {0}}            
        @guesses = Array.new(10) {Array.new()}
    end
    
    def display_board(win)
        if win
            p code
        else
            p Array.new(4) {"Ø"}
        end

        puts ""
        
        board.each_with_index do |row, i|
            print row
            print "     "
            p guesses[i]
        end
    end
end

game = Game.new
game.play