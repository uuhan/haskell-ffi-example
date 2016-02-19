module Main (main) where
import Foreign.C.String (withCString)
import Foreign (alloca, peek)
import Foreign.Ptr (nullFunPtr, nullPtr)

#include <bindings.dsl.h>
#include <sqlite3.h>
#strict_import

#opaque_t sqlite3

#ccall sqlite3_open, CString -> Ptr (Ptr <struct sqlite3>) -> IO CInt
#ccall sqlite3_exec, Ptr <struct sqlite3> -> CString -> (FunPtr (Ptr () -> CInt -> Ptr CString -> Ptr CString -> IO CInt)) -> Ptr () -> Ptr CString -> IO CInt

main :: IO ()
main = do
    ptr <- open "main.db"
    let stmt = "CREATE TABLE book(id integer, writter string)"
    exec stmt ptr 
    print stmt

open :: String -> IO (Ptr C'sqlite3)
open name = withCString name $ \c'name -> do
    alloca $ \ptr -> do
        _ <- c'sqlite3_open c'name ptr
        peek ptr

exec :: String -> Ptr C'sqlite3 -> IO ()
exec stmt db = do
    withCString stmt $ \c'stmt -> do
        c'sqlite3_exec db c'stmt nullFunPtr nullPtr nullPtr
        return ()
