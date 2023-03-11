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
    end

    def play
        win = false

        local_multiplayer = prompt_local_multiplayer?
        first_player_breaker = prompt_first_player_breaker?

        while !win
            break 
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
    
    def make_guess(code_guess)
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

board = Board.new
code_master = Player.new(board, false)
code_breaker = Player.new(board, true)
game = Game.new
game.play

code_master.make_code([1,2,3,4])

win = code_breaker.make_guess([2, 2, 4, 4])

board.display_board(win)