package stx.parse;


typedef EnumerableApi<C,T>    = stx.parse.core.Enumerable.EnumerableApi<C,T>;
typedef EnumerableCls<C,T>    = stx.parse.core.Enumerable.EnumerableCls<C,T>;
typedef Enumerable<C,T>       = stx.parse.core.Enumerable<C,T>;


typedef ParseSystemFailure    = stx.parse.core.ParseSystemFailure;

typedef ParseSuccess<P,T>     = stx.parse.core.ParseSuccess<P,T>;

typedef ParseErrorInfo        = stx.parse.core.ParseError.ParseErrorInfo;
typedef ParseError            = stx.parse.core.ParseError;
typedef ParseFailure<P>       = stx.parse.core.ParseFailure<P>;


typedef RestWithDef<P,T>      = stx.parse.core.RestWith.RestWithDef<P,T>;
typedef RestWith<P,T>         = stx.parse.core.RestWith<P,T>;

typedef Head                  = stx.parse.core.Head;
typedef LR                    = stx.parse.core.LR;
typedef LRLift                = stx.parse.core.LR.LRLift;

typedef Memo                  = stx.parse.core.Memo;
typedef MemoEntry             = stx.parse.core.Memo.MemoEntry;
typedef MemoKey               = stx.parse.core.Memo.MemoKey;
typedef UID                   = stx.parse.core.UID;
typedef Lung                  = stx.parse.core.Lung;