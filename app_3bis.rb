require "bundler"
Bundler.require

require_relative "lib/game_bis"
require_relative "lib/player"

puts "------------------------------------------------"
puts "|Bienvenue sur 'ILS VEULENT TOUS MA POO' !      |"
puts "|Le but du jeu est d'être le dernier survivant !|"
puts "-------------------------------------------------"
puts "C'est moi, le prof. CHEN ! Comment t'appelles-tu déjà ?"
print ">"
given_name = gets.chomp

game = Game.new(given_name)

while game.is_still_ongoing? == true
  game.show_players
  game.menu
  game.menu_choice
  game.enemies_attack
  puts "------------------------------------------------"
  sleep(1)
  game.new_players_in_sight
end

game.end
