
```
cabal run
```

```
# catchAndThrow
# Original exception in the WhileHandling, rethrown exception has new backtrace.

IOException
|
+- WhileHandling
|  |
|  `- IOException
|     |
|     `- Backtrace: HasCallStack backtrace:/  throwIO, called at app/Main.hs:30:7 ...
|
`- Backtrace: HasCallStack backtrace:/  throwIO, called at app/Main.hs:15:62 ...
```

```
# catchAndThrow'
# Original exception in the WhileHandling, rethrown exception has the new backtrace and also the old one.

IOException
|
+- WhileHandling
|  |
|  `- IOException
|     |
|     `- Backtrace: HasCallStack backtrace:/  throwIO, called at app/Main.hs:30:7 ...
|
+- Backtrace: HasCallStack backtrace:/  throwIO, called at app/Main.hs:20:84 ...
|
`- Backtrace: HasCallStack backtrace:/  throwIO, called at app/Main.hs:30:7 ...
```

```
# catchAndRethrow
# No WhileHandling indirection, the catch becomes invisible.

IOException
|
`- Backtrace: HasCallStack backtrace:/  throwIO, called at app/Main.hs:30:7 ...
```


