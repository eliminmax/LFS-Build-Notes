# Begin /etc/profile.d/rustc.sh

case ":$PATH:" in
	*:/opt/rustc/bin:*) ;;
	*) PATH="$PATH:/opt/rustc/bin"
esac

# End /etc/profile.d/rustc.sh
