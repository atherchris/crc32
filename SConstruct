env = Environment()
env['DPATH'] = '#/src'
env.Append( DFLAGS = [ '-w' ] )

if int( ARGUMENTS.get( 'debug', 0 ) ) == 1:
	env.Append( DFLAGS = [ '-g' ] )
elif int( ARGUMENTS.get( 'deploy', 0 ) ) == 1:
	env.Append( DFLAGS = [ '-release', '-O5' ] )

SConscript( 'src/SConscript', exports=[ 'env' ], variant_dir='build', duplicate=0 )
