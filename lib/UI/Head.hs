{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}

module UI.Head where

import Data.Foldable
import Data.Text
import Reflex.Dom

htmlHead ∷ MonadWidget t m ⇒ m ()
htmlHead = do
  elAttr
    "link"
    [ ("href", "https://cdn.jsdelivr.net/npm/bootstrap@5.3.8/dist/css/bootstrap.min.css"),
      ("rel", "stylesheet"),
      ("integrity", "sha384-sRIl4kxILFvY47J16cr9ZwB07vP4J8+LH7qKQnuqkuIAvNWLzeN8tE5YBujZqJLB"),
      ("crossorigin", "anonymous")
    ]
    blank
  elAttr
    "link"
    [ ("href", "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/5.15.4/css/all.min.css"),
      ("rel", "stylesheet")
    ]
    blank
  elAttr
    "link"
    [ ("href", "https://fonts.googleapis.com/css?family=Caudex"),
      ("rel", "stylesheet")
    ]
    blank
  elAttr
    "link"
    [ ("href", "https://fonts.googleapis.com/css?family=Lexend+Deca"),
      ("rel", "stylesheet")
    ]
    blank
  elAttr
    "link"
    [ ("href", "/css/index.css"),
      ("rel", "stylesheet")
    ]
    blank
  elAttr
    "link"
    [ ("href", "/img/jh.png"),
      ("rel", "shortcut icon")
    ]
    blank
  elAttr
    "meta"
    [ ("charset", "utf-8")
    ]
    blank
  elAttr "meta" [("http-equiv", "X-Who-Is-Baby: Raven")] blank
  traverse_ (\(name', content') -> elAttr "meta" [("name", name'), ("content", content')] blank) ([
    ("description", "JolHarg JobFinder helps you find and organise jobs."),
    -- ("keywords", intercalate "," ["jolharg", "jobfinder"]),
    ("Content-Type", "text/html; charset=utf-8"),
    ("X-Who-Is-Baby", "Raven"),
    ("X-UA-Compatible", "IE=edge,chrome=1"),
    ("viewport", "width=device-width, initial-scale=1"),
    ("favicon", "/jh.png")
    ] :: [(Text, Text)])
  el "title" $ text "JobFinder"
