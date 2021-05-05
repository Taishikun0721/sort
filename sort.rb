require 'byebug'
require 'benchmark'

class MySort
  attr_accessor :numbers
  def initialize(numbers = nil)
    @numbers = numbers || Array.new(100) { rand 100 }.uniq
  end

  def bubble_sort
    limits = (0..numbers.size - 2).to_a
    limits.each do |limit|
      for i in 0..(limits.size - 1 - limit) do
        if numbers[i] > numbers[i + 1]
          numbers[i], numbers[i + 1] = numbers[i + 1], numbers[i]
        end
      end
    end
    numbers
  end

  def quick_sort
    @result = []
    pivot = numbers.last
    partition(numbers, pivot, -1)
  end

  def merge_sort
    return if numbers.size <= 1 # 配列のサイズが1以下になったら、処理終了
    left = numbers[0..(numbers.size / 2 - 1)] # 配列の前半を算出
    right = numbers[(numbers.size / 2)..(numbers.size - 1)] # 配列の後半を算出
    MySort.new(left).merge_sort
    MySort.new(right).merge_sort

    left_index = 0
    rigth_index = 0
    index = 0
    while left_index < left.size && rigth_index < right.size do
      if left[left_index] <= right[rigth_index]
        numbers[index] = left[left_index]
        left_index += 1
      else
        numbers[index] = right[rigth_index]
        rigth_index += 1
      end
      index += 1
    end
    while left_index < left.size do
      numbers[index] = left[left_index]
      left_index += 1
      index += 1
    end
    while rigth_index < right.size do
      numbers[index] = right[rigth_index]
      rigth_index += 1
      index += 1
    end
    numbers
  end

  private

  def partition(numbers, pivot, pivot_index)
    numbers.each_with_index do |number, current_index|
      if smaller_than_pivot?(number, pivot)
        pivot_index += 1
        swap(numbers, current_index, pivot_index)
      end
    end
    if sort?(numbers)
      @result.concat(numbers)
    else
      partition(numbers[0..pivot_index - 1], numbers[0..pivot_index - 1].last, -1)
      partition(numbers[pivot_index + 1..numbers.count - 1], numbers[pivot_index + 1..numbers.count - 1].last, -1)
    end
    @result
  end

  def smaller_than_pivot?(number, pivot)
    number <= pivot
  end

  def sort?(numbers)
    numbers.inject do |default, next_num|
      return false unless default <= next_num
      next_num
    end
    true
  end

  def swap(numbers, current_index, pivot_index)
    numbers[pivot_index], numbers[current_index] = numbers[current_index], numbers[pivot_index]
  end
end

Benchmark.bm do |r|
  mysort = MySort.new

  r.report 'quick sort' do
    mysort.quick_sort
  end

  r.report 'merge sort' do
    mysort.merge_sort
  end

  r.report 'bubble sort' do
    mysort.bubble_sort
  end

  r.report 'original sort' do
    mysort.numbers.sort
  end
end