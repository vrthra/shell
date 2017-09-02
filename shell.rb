#!/usr/bin/env ruby
require 'parslet'
require 'readline'
require 'pp'

$pids = []

def main
  while cmdline = Readline.readline("> ", true)
    tree = parse_cmdline(cmdline)
    next if tree == :empty
    $pids = tree.execute($stdin.fileno, $stdout.fileno)
    $pids.each do |pid|
      Process.wait(pid)
    end
  end
  puts ''
end

def parse_cmdline(cmdline)
  raw_tree = Parser.new.parse(cmdline)
  Transform.new.apply(raw_tree)
end

class Parser < Parslet::Parser
  root :cmdline

  rule(:cmdline) { pipeline | command | space?.as(:empty) }
  rule(:pipeline) { command.as(:left) >> pipe.as(:pipe) >> cmdline.as(:right) }
  rule(:command) { arg.as(:arg).repeat(1).as(:command) }
  rule(:arg) { bare_arg | quoted_arg }

  rule(:bare_arg) { match[%q{^\s'|}].repeat(1) >> space? }
  rule(:quoted_arg) { str("'").ignore >> match[%q{^'}].repeat(0) >> str("'").ignore >> space? }
  rule(:pipe) { str("|") >> space? }

  rule(:space?) { space.maybe }
  rule(:space) { match[%q{\s}].repeat(1).ignore }
end

class Transform < Parslet::Transform
  rule(left: subtree(:left), pipe: "|", right: subtree(:right)) { Pipeline.new(left, right) }
  rule(command: sequence(:args)) { Command.new(args) }
  rule(arg: simple(:arg)) { arg }
  rule(empty: simple(:empty)) { :empty }
end

class Pipeline
  def initialize(left, right)
    @left  = left 
    @right = right 
  end

  def execute(stdin, stdout)
    reader, writer = IO.pipe
    pids = @left.execute(stdin, writer.fileno) + @right.execute(reader.fileno, stdout)
    reader.close
    writer.close
    return pids
  end
end

class Command
  def initialize(args)
    @args = args
  end

  def execute(stdin, stdout)
    [spawn(*@args, 0 => stdin, 1 => stdout)]
  end
end

def shutdown
end

# Trap ^C 
Signal.trap("INT") do
  $pids.each do |pid|
    Process.kill("INT", pid)
  end
end

# Trap `Kill `
Signal.trap("TERM") do
  $pids.each do |pid|
    Process.kill("TERM", pid)
  end
end

main
