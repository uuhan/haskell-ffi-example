module Main (main) where

import Foreign
import Foreign.Ptr
import Foreign.C.Types
import Foreign.C.String

#include <sqlite3.h>

type Sqlite3 = {# type sqlite3 #}

{# fun unsafe sqlite3_open as ^
    {
        `CString',
        alloca- `Sqlite3' peek*
    } -> `Int' void-
#}

{# fun unsafe sqlite3_exec as ^
    {
        id `Sqlite3',
        `CString',
        id `FunPtr (Ptr () -> CInt -> Ptr CString -> Ptr CString -> IO CInt)',
        id `Ptr ()',
        id `Ptr CString'
    } -> `Int' void-
#}

main :: IO ()
main = do
    open "main.db" >>= 
        exec "CREATE TABLE main(id integer, language string)"

open :: String -> IO Sqlite3
open name = do
    withCString name $ \c'name -> do
        sqlite3Open c'name

exec :: String -> Sqlite3 -> IO ()
exec stmt db = do 
    withCString stmt $ \c'stmt -> do
        sqlite3Exec db c'stmt nullFunPtr nullPtr nullPtr
