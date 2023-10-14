{-# LANGUAGE MonoLocalBinds    #-}
{-# LANGUAGE OverloadedLists   #-}
{-# LANGUAGE OverloadedStrings #-}

module UI.Head where

import Data.Text
import Reflex.Dom

htmlHead ∷ MonadWidget t m ⇒ m ()
htmlHead = do
  elAttr
    "link"
    [ ("href", "https://cdn.jsdelivr.net/npm/bootstrap@5.1.1/dist/css/bootstrap.min.css"),
      ("rel", "stylesheet"),
      ("integrity", "sha384-F3w7mX95PdgyTmZZMECAngseQB83DfGTowi0iMjiWaeVhAn4FJkqJByhZMI3AhiU"),
      ("crossorigin", "anonymous")
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
  elAttr "meta" [("http-equiv", "X-Who-Is-Awesome: Raven")] blank
  mapM_ (\(name', content') -> elAttr "meta" [("name", name'), ("content", content')] blank) ([
    ("description", "JolHarg JobFinder helps you find and organise jobs."),
    ("keywords", intercalate "," ["jolharg", "jobfinder"]),
    ("Content-Type", "text/html; charset=utf-8"),
    ("Who-is-awesome", "Raven"),
    ("X-UA-Compatible", "IE=edge,chrome=1"),
    ("viewport", "width=device-width, initial-scale=1"),
    ("favicon", "/jh.png")
    ] :: [(Text, Text)])
  el "title" $ text "JobFinder"
