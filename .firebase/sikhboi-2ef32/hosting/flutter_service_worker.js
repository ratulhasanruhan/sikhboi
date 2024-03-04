'use strict';
const MANIFEST = 'flutter-app-manifest';
const TEMP = 'flutter-temp-cache';
const CACHE_NAME = 'flutter-app-cache';

const RESOURCES = {"assets/AssetManifest.bin": "f96cd097683f1bf6450e780c4556dff3",
"assets/AssetManifest.json": "21b44e32f8b257386e9e96bef2fdda14",
"assets/assets/add_avatar.png": "888608c6e468438b994f0ef11ee13ec2",
"assets/assets/add_image.png": "e8f7265e78cbc4de76d6930d81e8c1c9",
"assets/assets/add_video.png": "c681a5eabce426ac9e289785a2a4ccf2",
"assets/assets/avatar.png": "0ab310f4f4cabebd6f860125cfa0f5d7",
"assets/assets/badge.json": "81c0f198b47d0cdde5f996cb425315e6",
"assets/assets/confetti.json": "fcc5146904ece2beaf407b15b841de2e",
"assets/assets/dictionary.json": "5d18964d91fec40931e90c2adcd4c7b2",
"assets/assets/email.png": "4cef03675a4f6ef35c9cd52e1b84e434",
"assets/assets/error.json": "13a90627e1fd3c7e48fb94be5ccd408b",
"assets/assets/fonts/Ador-Bold.ttf": "3ba33794c84e1da666ef78c8a9034cab",
"assets/assets/fonts/Ador-Light.ttf": "455a48e4ef316411f956fff512d1cdd1",
"assets/assets/fonts/Ador-Regular.ttf": "a9bab4af564b06c78af32877ddc8d23d",
"assets/assets/fonts/Ador-SemiBold.ttf": "53b43721854127c319c8ae7beee24861",
"assets/assets/free.json": "637305ccad02b1e8bb20b4f10994f7bb",
"assets/assets/gold.json": "64f3d0b9b40eb7fe287f08078920971e",
"assets/assets/icon.png": "722b800de0c8899ba4e74126af30617a",
"assets/assets/img.png": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/knowledge.json": "8bf53514e1891248600bf3ddf9c23dc7",
"assets/assets/launcher.png": "60d53d8dcb424dfe579109fa8e425d54",
"assets/assets/learn.json": "9db4b3273e4279180c4d645100dafce9",
"assets/assets/live.json": "115a37cd44f7ff82f6476dcd0a4dcdd8",
"assets/assets/logo.png": "d97c5d9bdbdd7ae6ad2a5770f42aeef8",
"assets/assets/logo_h.png": "5ad715c3b5c82605ca4b8efcdb9a4b01",
"assets/assets/permission.png": "1701412ffeabaa1969e8543d27e2820d",
"assets/assets/premium.json": "7773da6587322f055942ac3e9fb4e83a",
"assets/assets/salary.png": "b3fa70235c773796d98869c70eaf7f27",
"assets/assets/success.gif": "d41d8cd98f00b204e9800998ecf8427e",
"assets/assets/success.json": "a9dc8e28f8b089728ae910ec4f4cddd3",
"assets/assets/timer.json": "fe8be8a68f0f92b5a08b5c8ce60ec607",
"assets/assets/upgrade.json": "fad13729b0ff3e3311da4b2943821b5e",
"assets/assets/uploading.json": "5cc5e68ae1ee00d4f605baead14f4329",
"assets/assets/video_clip.json": "9400266d3a1230e9333a606867b8240d",
"assets/FontManifest.json": "cd7003aba44aeaa49dd01a062a87c7c6",
"assets/fonts/MaterialIcons-Regular.otf": "a5873597eef562bb8afc5ed116f61f70",
"assets/NOTICES": "5309d30c8b3b699c70dbf06feb6258eb",
"assets/packages/comment_box/assets/img/userpic.jpg": "158db63eb82bd6445b7fd976fe3ecefb",
"assets/packages/cool_alert/assets/flare/error_check.flr": "d9f54791d0d79935d22206966707e4b3",
"assets/packages/cool_alert/assets/flare/info_check.flr": "f6b81c2aa3ae36418c13bfd36d11ac04",
"assets/packages/cool_alert/assets/flare/loading.flr": "b6987a8e6de74062b8c002539d2d043e",
"assets/packages/cool_alert/assets/flare/success_check.flr": "9d163bcc6f6b58566e0abde7761a67a0",
"assets/packages/cool_alert/assets/flare/warning_check.flr": "ff4a110b8d905dedb4d4639a17399703",
"assets/packages/cupertino_icons/assets/CupertinoIcons.ttf": "639b388cd7274f02621506c28435502d",
"assets/packages/dash_chat_2/assets/placeholder.png": "ce1fece6c831b69b75c6c25a60b5b0f3",
"assets/packages/dash_chat_2/assets/profile_placeholder.png": "77f5794e2eb49f7989b8f85e92cfa4e0",
"assets/packages/flutterfire_ui/assets/countries.json": "8c937aac9f3b69162be779fbcd6199d2",
"assets/packages/flutterfire_ui/assets/fonts/SocialIcons.ttf": "c6d1e3f66e3ca5b37c7578e6f80f37d8",
"assets/packages/flutterfire_ui/assets/icons/apple_dark.svg": "1b587ffd7d75c462847f8137a93f3161",
"assets/packages/flutterfire_ui/assets/icons/apple_light.svg": "2508cc7c5d302fd37edff1b87fedb594",
"assets/packages/flutterfire_ui/assets/icons/facebook.svg": "5fad3daafe7c7c5163fca56662d2738a",
"assets/packages/flutterfire_ui/assets/icons/google.svg": "3b5ceaea5e2391782d39df225a375d5d",
"assets/packages/flutterfire_ui/assets/icons/twitter.svg": "6086e2aad26effea1344c8e118520e32",
"assets/packages/fluttertoast/assets/toastify.css": "a85675050054f179444bc5ad70ffc635",
"assets/packages/fluttertoast/assets/toastify.js": "56e2c9cedd97f10e7e5f1cebd85d53e3",
"assets/packages/flutter_feather_icons/fonts/feather.ttf": "40469726c5ed792185741388e68dd9e8",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.css": "5a8d0222407e388155d7d1395a75d5b9",
"assets/packages/flutter_inappwebview/assets/t_rex_runner/t-rex.html": "16911fcc170c8af1c5457940bd0bf055",
"assets/packages/wakelock_web/assets/no_sleep.js": "7748a45cd593f33280669b29c2c8919a",
"assets/packages/youtube_player_flutter/assets/speedometer.webp": "50448630e948b5b3998ae5a5d112622b",
"assets/packages/youtube_player_iframe/assets/player.html": "dc7a0426386dc6fd0e4187079900aea8",
"assets/shaders/ink_sparkle.frag": "f8b80e740d33eb157090be4e995febdf",
"canvaskit/canvaskit.js": "bbf39143dfd758d8d847453b120c8ebb",
"canvaskit/canvaskit.wasm": "19d8b35640d13140fe4e6f3b8d450f04",
"canvaskit/chromium/canvaskit.js": "96ae916cd2d1b7320fff853ee22aebb0",
"canvaskit/chromium/canvaskit.wasm": "1165572f59d51e963a5bf9bdda61e39b",
"canvaskit/skwasm.js": "95f16c6690f955a45b2317496983dbe9",
"canvaskit/skwasm.wasm": "d1fde2560be92c0b07ad9cf9acb10d05",
"canvaskit/skwasm.worker.js": "51253d3321b11ddb8d73fa8aa87d3b15",
"favicon.png": "d41d8cd98f00b204e9800998ecf8427e",
"flutter.js": "6b515e434cea20006b3ef1726d2c8894",
"icons/Icon-192.png": "d41d8cd98f00b204e9800998ecf8427e",
"icons/Icon-512.png": "d41d8cd98f00b204e9800998ecf8427e",
"icons/Icon-maskable-192.png": "d41d8cd98f00b204e9800998ecf8427e",
"icons/Icon-maskable-512.png": "d41d8cd98f00b204e9800998ecf8427e",
"index.html": "d9477fb88274ce13d5ca16526ba660fb",
"/": "d9477fb88274ce13d5ca16526ba660fb",
"main.dart.js": "c53e907886717f577b130633afcf0f5b",
"manifest.json": "b29df77b977020c8fe469ff2ed11504f",
"splash/img/dark-1x.png": "ceaf8abb52ecfcd938db1d94b607f18f",
"splash/img/dark-2x.png": "0983456ad08252c8a49bf07687518104",
"splash/img/dark-3x.png": "c346af01c0371d70727a31613584af8e",
"splash/img/dark-4x.png": "8dd99d3ae1997d8dc37e25a93a27977d",
"splash/img/light-1x.png": "ceaf8abb52ecfcd938db1d94b607f18f",
"splash/img/light-2x.png": "0983456ad08252c8a49bf07687518104",
"splash/img/light-3x.png": "c346af01c0371d70727a31613584af8e",
"splash/img/light-4x.png": "8dd99d3ae1997d8dc37e25a93a27977d",
"splash/splash.js": "123c400b58bea74c1305ca3ac966748d",
"splash/style.css": "c94c38ff00a9d487c353a2d78989ea08",
"version.json": "94b6a0ff9f6e95040ae243b7393325a7"};
// The application shell files that are downloaded before a service worker can
// start.
const CORE = ["main.dart.js",
"index.html",
"assets/AssetManifest.json",
"assets/FontManifest.json"];

// During install, the TEMP cache is populated with the application shell files.
self.addEventListener("install", (event) => {
  self.skipWaiting();
  return event.waitUntil(
    caches.open(TEMP).then((cache) => {
      return cache.addAll(
        CORE.map((value) => new Request(value, {'cache': 'reload'})));
    })
  );
});
// During activate, the cache is populated with the temp files downloaded in
// install. If this service worker is upgrading from one with a saved
// MANIFEST, then use this to retain unchanged resource files.
self.addEventListener("activate", function(event) {
  return event.waitUntil(async function() {
    try {
      var contentCache = await caches.open(CACHE_NAME);
      var tempCache = await caches.open(TEMP);
      var manifestCache = await caches.open(MANIFEST);
      var manifest = await manifestCache.match('manifest');
      // When there is no prior manifest, clear the entire cache.
      if (!manifest) {
        await caches.delete(CACHE_NAME);
        contentCache = await caches.open(CACHE_NAME);
        for (var request of await tempCache.keys()) {
          var response = await tempCache.match(request);
          await contentCache.put(request, response);
        }
        await caches.delete(TEMP);
        // Save the manifest to make future upgrades efficient.
        await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
        // Claim client to enable caching on first launch
        self.clients.claim();
        return;
      }
      var oldManifest = await manifest.json();
      var origin = self.location.origin;
      for (var request of await contentCache.keys()) {
        var key = request.url.substring(origin.length + 1);
        if (key == "") {
          key = "/";
        }
        // If a resource from the old manifest is not in the new cache, or if
        // the MD5 sum has changed, delete it. Otherwise the resource is left
        // in the cache and can be reused by the new service worker.
        if (!RESOURCES[key] || RESOURCES[key] != oldManifest[key]) {
          await contentCache.delete(request);
        }
      }
      // Populate the cache with the app shell TEMP files, potentially overwriting
      // cache files preserved above.
      for (var request of await tempCache.keys()) {
        var response = await tempCache.match(request);
        await contentCache.put(request, response);
      }
      await caches.delete(TEMP);
      // Save the manifest to make future upgrades efficient.
      await manifestCache.put('manifest', new Response(JSON.stringify(RESOURCES)));
      // Claim client to enable caching on first launch
      self.clients.claim();
      return;
    } catch (err) {
      // On an unhandled exception the state of the cache cannot be guaranteed.
      console.error('Failed to upgrade service worker: ' + err);
      await caches.delete(CACHE_NAME);
      await caches.delete(TEMP);
      await caches.delete(MANIFEST);
    }
  }());
});
// The fetch handler redirects requests for RESOURCE files to the service
// worker cache.
self.addEventListener("fetch", (event) => {
  if (event.request.method !== 'GET') {
    return;
  }
  var origin = self.location.origin;
  var key = event.request.url.substring(origin.length + 1);
  // Redirect URLs to the index.html
  if (key.indexOf('?v=') != -1) {
    key = key.split('?v=')[0];
  }
  if (event.request.url == origin || event.request.url.startsWith(origin + '/#') || key == '') {
    key = '/';
  }
  // If the URL is not the RESOURCE list then return to signal that the
  // browser should take over.
  if (!RESOURCES[key]) {
    return;
  }
  // If the URL is the index.html, perform an online-first request.
  if (key == '/') {
    return onlineFirst(event);
  }
  event.respondWith(caches.open(CACHE_NAME)
    .then((cache) =>  {
      return cache.match(event.request).then((response) => {
        // Either respond with the cached resource, or perform a fetch and
        // lazily populate the cache only if the resource was successfully fetched.
        return response || fetch(event.request).then((response) => {
          if (response && Boolean(response.ok)) {
            cache.put(event.request, response.clone());
          }
          return response;
        });
      })
    })
  );
});
self.addEventListener('message', (event) => {
  // SkipWaiting can be used to immediately activate a waiting service worker.
  // This will also require a page refresh triggered by the main worker.
  if (event.data === 'skipWaiting') {
    self.skipWaiting();
    return;
  }
  if (event.data === 'downloadOffline') {
    downloadOffline();
    return;
  }
});
// Download offline will check the RESOURCES for all files not in the cache
// and populate them.
async function downloadOffline() {
  var resources = [];
  var contentCache = await caches.open(CACHE_NAME);
  var currentContent = {};
  for (var request of await contentCache.keys()) {
    var key = request.url.substring(origin.length + 1);
    if (key == "") {
      key = "/";
    }
    currentContent[key] = true;
  }
  for (var resourceKey of Object.keys(RESOURCES)) {
    if (!currentContent[resourceKey]) {
      resources.push(resourceKey);
    }
  }
  return contentCache.addAll(resources);
}
// Attempt to download the resource online before falling back to
// the offline cache.
function onlineFirst(event) {
  return event.respondWith(
    fetch(event.request).then((response) => {
      return caches.open(CACHE_NAME).then((cache) => {
        cache.put(event.request, response.clone());
        return response;
      });
    }).catch((error) => {
      return caches.open(CACHE_NAME).then((cache) => {
        return cache.match(event.request).then((response) => {
          if (response != null) {
            return response;
          }
          throw error;
        });
      });
    })
  );
}
