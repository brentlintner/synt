def bar
  a = lambda {
    print 'hey!'
  }

  a.call
end
