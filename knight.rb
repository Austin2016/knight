class Square 
  
  FILE_LETTERS = ["a","b","c","d","e","f","g","h"]
  SIZE = 7
  
  def initialize(file,rank) 
    @file = file              #horizontal 
    @rank = rank              #vertical 
  end 

  def file
    @file
  end 

  def rank
  	@rank
  end 
  
  def is_valid?
    @file >=0 && @file <=SIZE && @rank >=0 && @rank <= SIZE
  end
  
  def to_s
  	if !self.is_valid?
      return "##" 
  	end
    FILE_LETTERS[@file] + (@rank + 1).to_s
  end 

  def == (other)
    self.file == other.file && self.rank == other.rank
  end

  def hash 
    @file 
  end

  def eql? (other)
    self == other 
  end 

end 

class Moves      #all possible next squares 
  
  def self.possible_moves(from_square)  
    if !from_square.is_valid?
      return nil
    end 

    array = []
    array << Square.new(from_square.file + 2, from_square.rank + 1)
    array << Square.new(from_square.file + 2, from_square.rank - 1)
    array << Square.new(from_square.file - 2, from_square.rank + 1)
    array << Square.new(from_square.file - 2, from_square.rank - 1)
    array << Square.new(from_square.file + 1, from_square.rank + 2)
    array << Square.new(from_square.file + 1, from_square.rank - 2)
    array << Square.new(from_square.file - 1, from_square.rank + 2)
    array << Square.new(from_square.file - 1, from_square.rank - 2)
    
    array.select { |e| e.is_valid? }
  end 

end 

class Node 
  
  attr_reader :square, :children  

  def initialize (square,list)
    @square = square 
    @children = list
  end   

end 

class Tree  
  
  attr_reader :root
  
  def initialize (node)
    @root = node 
  end


  def search(square)
    Tree.search_node(@root,square)
  end

private

  def self.search_node (node,square)
    return nil  if node == nil 
    return [node.square]  if node.square == square
    
    node.children.each do |child|
      path = self.search_node(child,square)
      return [node.square] + path if path != nil 
    end 
    nil 
  end 

   

end 

class Solve 

  def self.build_tree(square)
    node = Node.new(square,[])
    tree = Tree.new(node)

    square_list = [tree.root.square]
    unexpanded_nodes = [tree.root]
      

    until unexpanded_nodes == []
      new_leaves = []
      unexpanded_nodes.each do |e|
        next_squares =  Moves.possible_moves( e.square  ).select { |e| !square_list.include?(e) } 
        for i in 0..next_squares.length - 1 
          var = Node.new( next_squares[i],[] )  #smells that i can write to a read only @ variable         
          e.children << var 
          new_leaves << var 
        end
        square_list += next_squares
      end
      unexpanded_nodes = new_leaves 
    end
    tree        
  end 

end

my_square =Square.new(3,7) #create a square to find the shortest path to
tree = Solve.build_tree( Square.new(0,0) ) #create a search tree and a starting point 
puts tree.search(my_square) #search the tree starting at a1 to display the shortest path to d8

  








=begin
 
class ShortestPath 
  
  def self.distance (a,b)
    Math.sqrt( (a.rank - b.rank)**2 + (a.file - b.file)**2 ) 
  end
  
  def self.find_shortest_path(from_square,destination_square,exclude) 
    original_distance = self.distance( from_square , destination_square )

    if from_square == destination_square
      return [from_square]
    end 
     
    next_moves_array = Moves.possible_moves(from_square) - exclude 
    if original_distance > 3 
      array = [] 
      next_moves_array.each { |e| array << distance(e,destination_square)  }
      smallest_value_in_array = array.min()
      index_of_smallest_value_in_array = array.index( smallest_value_in_array )
      if index_of_smallest_value_in_array != nil 
        next_moves_array = [ next_moves_array[ index_of_smallest_value_in_array ] ]
      end       
    else
      array = next_moves_array.select { |e| distance(e,destination_square) < 3 }
      next_moves_array = array if array.length !=0

    end   
    shortest_path = nil 
    while next_moves_array.length != 0 
      move = next_moves_array.slice!(0)
      a_path = self.find_shortest_path(move, destination_square, exclude + [from_square]) 
      if a_path != nil
        if shortest_path == nil  
          shortest_path = a_path
        elsif a_path.length < shortest_path.length 
          shortest_path = a_path
        end
      end   
    end
    if shortest_path == nil
      return nil
    end
    [from_square] + shortest_path     
  end 




end 
 


excluded_squares = []

for rank in (0..7)
  puts ""
  for file in (0..7) 
  	start = Square.new(rank,file)
    a = ShortestPath.find_shortest_path( start, destination, excluded_squares )
    print " #{a.length}"    
  end
end
puts "" 
=end 







