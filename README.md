# Vector-cloud

Programs that make Vector talk to the cloud!

## Building

To make it easy to cross-compile binaries on your computer that will
run on Vector you'll first need the armbuilder docker image.  It can
be generated by running..

```
# make docker-builder
```

To build vic-cloud, run...
```
# make vic-cloud
```

To build vic-gateway, run...
```
# make vic-gateway
```
## Development
If you have vector with ssh enabled you can you use the following to easily upload the
generated binaries.

```
# make upload-on-vector 
```

The make command assumes that you have the robot ip saved under the ROBOT_IP, which is 
a comman practise while developing on vector robots. If you dont have that setup you can 
use the following.

```
# make upload-on-vector ROBOT_IP=192.168.65.97
```

## Example Customization

Let's have Vector refuse to give users information on Area 51 and then
explictly state that all other information requests have been approved.

First we make the following changes to `internal/voice/stream/context.go`

```diff
diff --git a/internal/voice/stream/context.go b/internal/voice/stream/context.go
index 1d5df2c..564b22f 100644
--- a/internal/voice/stream/context.go
+++ b/internal/voice/stream/context.go
@@ -1,7 +1,9 @@
 package stream
 
 import (
-       "bytes"
+       "regexp"
+       
+       "bytes"
        "context"
        "encoding/json"
        "fmt"
@@ -155,6 +157,14 @@ func sendIntentResponse(resp *chipper.IntentResult, receiver Receiver) {
 
 func sendKGResponse(resp *chipper.KnowledgeGraphResponse, receiver Receiver) {
        var buf bytes.Buffer
+
+       found, _ := regexp.MatchString("area fifty one", resp.QueryText)
+       if found {
+         resp.SpokenText = "Information regarding Area Fifty One is classified. The Illuminati High Council has been notified of this request."
+       } else {
+         resp.SpokenText = "Information Request Approved. " + resp.SpokenText
+       }
+
        params := map[string]string{
                "answer":      resp.SpokenText,
                "answer_type": resp.CommandType,
```

Next compile, copy to Vector, and reboot.

```bash
grant@lord-humungus vector-cloud % make vic-cloud                        
echo `go version` && cd /Users/grant/src/vector-cloud && go mod download
  ... BUILD LOG OUTPUT ...
Packed 1 file.
grant@lh % ssh root@<VECTOR_IP> mount -o remount,rw /
grant@lh % scp build/vic-cloud root@<VECTOR_IP>:/anki/bin
vic-cloud                                              100% 4800KB   3.6MB/s   00:01    
grant@lh %                                                 
grant@lh % ssh root@<VECTOR_IP> /sbin/reboot            
```

And test after the reboot by saying "Hey Vector... Question... What is Area 51?" and
"Hey Vector... Question... What is DogeCoin?"

