module Exercise12 exposing (Tree(..), decoder)


import Json.Decode
    exposing
        ( Decoder
        , fail
        , map2
        , lazy
        , oneOf
        , string
        , int
        , list
        , field
        )

{- There's one more interesting use case we've completely skipped so far.
   Handling recursive data. So let's set the record straight.

   Recursive decoders look almost exactly like any other decoder, except for
   one thing, and that one - very essential - things, stems from the fact that
   Elm is an eager language: every expression is executed as soon as all
   parameters are available. When defining a recursive decoder, we're defining functions that don't explicitly take input; so their parameters are available, and you get into a self-refential loop.

   Now, of course, the Elm compiler has your back, and will dutifully tell you
   that you cannot do that, and even point out how to fix it. Thanks, Elm!

   Example input:

        var input = { "name": "parent", "children": [
            { "name": "foo", "value": 5 },
            { "name": "empty", "children": [] }
        ]};

    Example output:

        Branch "parent"
            [ Leaf "foo" 5
            , Branch "empty" []
            ]

   -- NOTE: if you run into a runtime exception with your decoder; please read
   [this document](TODO: link)
-}


type
    Tree
    -- Either a branch with a name and a list of subtrees
    = Branch String (List Tree)
      -- Or we're at a leaf, and we just have a name and a value
    | Leaf String Int

decoder : Decoder Tree
decoder =
    --fail "I'm not a tree."
    oneOf
        [ lazy (\_ -> branchDecoder)
        , leafDecoder
        ]


branchDecoder : Decoder Tree
branchDecoder =
    map2 Branch
        (field "name" string)
        (field "children" (list <| lazy (\_ -> decoder)))


leafDecoder : Decoder Tree
leafDecoder =
    map2 Leaf
        (field "name" string)
        (field "value" int)



{- Once you think you're done, run the tests for this exercise from the root of
   the project:

   - If you have installed `elm-test` globally:
        `elm test tests/Exercise12`

   - If you have installed locally using `npm`:
        `npm run elm-test tests/Exercise12`

   - If you have installed locally using `yarn`:
        `yarn elm-test tests/Exercise12`
-}
