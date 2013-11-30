# Conway's Game of Life

A Haskell implementation using a list zipper of list zippers (or, a "plane zipper"), derived from Etienne Millon's brilliant blog post, [*Comonadic Life*] [1].

When run, the program prints out the first 5 stages (one full rotation) of the famous glider pattern:

    $ cabal run
    
    
    
    
    
    
           *
            *
          ***
    
    
    
    
    
    
    
    
    
    
          * *
           **
           *
    
    
    
    
    
    
    
    
    
            *
          * *
           **
    
    
    
    
    
    
    
    
    
           *
            **
           **
    
    
    
    
    
    
    
    
    
            *
             *
           ***
    
    
    

  [1]: http://blog.emillon.org/posts/2012-10-18-comonadic-life.html
