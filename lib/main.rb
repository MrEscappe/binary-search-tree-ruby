# frozen_string_literal: true

class Node
  attr_accessor :data, :left, :right

  def initialize(data = nil, left = nil, right = nil)
    @data = data
    @left = left
    @right = right
  end
end

class Tree
  attr_accessor :root

  def initialize(arr)
    new_arr = sort_arr(arr)
    @root = build_tree(new_arr)
  end

  def build_tree(arr)
    return nil if arr.empty?

    mid = arr.length / 2
    new_root = Node.new(arr[mid])
    new_root.left = build_tree(arr[0...mid])
    new_root.right = build_tree(arr[mid + 1...])
    new_root
  end

  def insert(value, root = @root)
    return @root = Node.new(value) if @root.nil?
    return Node.new(value) if root.nil?

    if root.data < value
      root.right = insert(value, root.right)
    else
      root.left = insert(value, root.left)
    end
    root
  end

  def delete(value, root = @root)
    return root if root.nil?

    temp_root = root
    if value < temp_root.data
      temp_root.left = delete(value, temp_root.left)
    elsif value > temp_root.data
      temp_root.right = delete(value, temp_root.right)
    else
      if temp_root.left.nil?
        temp = temp_root.right
        temp_root = nil
        return temp
      elsif temp_root.right.nil?
        temp = temp_root.left
        temp_root = nil
        return temp
      end

      temp = min_node_value(temp_root.right)
      temp_root.data = temp.data
      temp_root.right = delete(temp.data, temp_root.right)
    end
    temp_root
  end

  def min_node_value(node)
    current = node
    current = current.left until current.left.nil?
    current
  end

  def find(value, root = @root)
    return nil if root.nil?
    return root if root.data == value

    root.data < value ? find(value, root.right) : find(value, root.left)
  end

  def level_order(root = @root, queue = [])
    return root if root.nil?

    arr = []
    queue << root
    while queue.length.positive?
      arr << queue[0].data
      root = queue.shift

      queue << root.left unless root.left.nil?

      queue << root.right unless root.right.nil?
    end
    arr
  end

  def inorder(root = @root, arr = [])
    return root if root.nil?

    unless root.nil?
      inorder(root.left, arr)
      arr << root.data
      inorder(root.right, arr)
    end
    arr
  end

  def preorder(root = @root, arr = [])
    return root if root.nil?

    unless root.nil?
      arr << root.data
      preorder(root.left, arr)
      preorder(root.right, arr)
    end
    arr
  end

  def postorder(root = @root, arr = [])
    return root if root.nil?

    unless root.nil?
      postorder(root.left, arr)
      postorder(root.right, arr)
      arr << root.data
    end
    arr
  end

  def height(root = @root)
    return 0 if root.nil?

    [height(root.left), height(root.right)].max + 1
  end

  def depth(root = @root)
    return 0 if root.nil?

    left_depth = depth(root.left)
    right_depth = depth(root.right)

    if left_depth > right_depth
      left_depth + 1
    else
      right_depth + 1
    end
  end

  def balanced?(root = @root)
    return true if root.nil?

    left_height = height(root.left)
    right_height = height(root.right)

    if (left_height.abs - right_height.abs <= 1) && balanced?(root.left) == true && balanced?(root.right) == true
      true
    else
      false
    end
  end

  def rebalance
    @root = build_tree(level_order)
  end

  def sort_arr(arr)
    arr.uniq.sort
  end

  def pretty_print(node = @root, prefix = '', is_left = true)
    pretty_print(node.right, "#{prefix}#{is_left ? '│   ' : '    '}", false) if node.right
    puts "#{prefix}#{is_left ? '└── ' : '┌── '}#{node.data}"
    pretty_print(node.left, "#{prefix}#{is_left ? '    ' : '│   '}", true) if node.left
  end
end

array = Array.new(10) { rand(1..100) }

tree = Tree.new(array)

puts "The tree is balanced? #{tree.balanced?}"
puts ''
puts tree.pretty_print
puts ''
print tree.level_order
puts ''
print tree.preorder
puts ''
print tree.postorder
puts ''
print tree.inorder
puts ''
100.times do
  tree.insert(rand(1..100))
end

puts "The tree is balanced? #{tree.balanced?}"
puts ''
puts tree.pretty_print
puts ''
tree.rebalance
puts "The tree is balanced? #{tree.balanced?}"
puts ''
puts tree.pretty_print
puts ''
print tree.level_order
puts ''
print tree.preorder
puts ''
print tree.postorder
puts ''
print tree.inorder
