extends Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var crypto = Crypto.new()
	var key = crypto.generate_rsa(4096)
	var cert = crypto.generate_self_signed_certificate(key, "CN=game.reitan.dev,O=Snikur,C=IT")

	key.save("user://generated.key")
	cert.save("user://generated.crt")

	var data = "Some data"
	var encrypted = crypto.encrypt(key, data.to_utf8_buffer())
	var decrypted = crypto.decrypt(key, encrypted)
	var signature = crypto.sign(HashingContext.HASH_SHA256, data.sha256_buffer(), key)
	var verified = crypto.verify(HashingContext.HASH_SHA256, data.sha256_buffer(), signature, key)
	assert(verified)
	assert(data.to_utf8_buffer() == decrypted)
