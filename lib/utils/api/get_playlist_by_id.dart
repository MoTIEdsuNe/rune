import 'package:player/messages/playlist.pb.dart';

Future<PlaylistWithoutCoverIds> getPlaylistById(int playlistId) async {
  final fetchMediaFiles = GetPlaylistByIdRequest(playlistId: playlistId);
  fetchMediaFiles.sendSignalToRust(); // GENERATED

  // Listen for the response from Rust
  final rustSignal = await GetPlaylistByIdResponse.rustSignalStream.first;
  final playlist = rustSignal.message.playlist;

  return playlist;
}
