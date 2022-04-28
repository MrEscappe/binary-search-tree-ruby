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

  def search(value, root = @root)
    return nil if root.nil?
    return root if root.data == value

    root.data < value ? search(value, root.right) : search(value, root.left)
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

li = Tree.new(array)

li.pretty_print

li.insert(90)

li.pretty_print
