
namespace NeoLayoutViewer{
				class ConfigManager {

				//public Gee.HashMap<string,string> config = new Gee.HashMax<string,string>();
				//public Gee.HashMap<string,string> config { get; set; default = new Gee.HashMap<string, string>();};
				public Gee.HashMap<string,string> config;// { get; set; };

						public ConfigManager(string conffile) {
								this.config =  new Gee.HashMap<string, string>();

								//add defaults values, if key not set in the config file
								add_defaults();

								if(!search_config_file(conffile))
										create_conf_file(conffile);

								if(search_config_file(conffile))
									load_config_file(conffile);


								add_intern_values();
						}

						public Gee.HashMap<string, string> getConfig(){
								return config;
						}

						/*
							Standardwerte der Einstellungen. Sie werden in eine Konfigurationsdatei geschrieben, falls
							diese Datei nicht vorhanden ist.
						*/
						public void add_defaults(){
										config.set("show_shortcut","<Mod4><Super_L>N");
										config.set("on_top","1");
									  config.set("position","5");
									  config.set("width","1000");//Skalierung, sofern wert zwischen width(resolution)*max_width und width(resolution)*min_width
									  config.set("min_width","0.25");//Relativ zur Auflösung
									  config.set("max_width","0.5");//Relativ zur Auflösung
									  config.set("move_shortcut","<Mod4><Super_L>R");
									  //config.set("position_cycle","3 3 9 1 3 9 1 7 7");
									  config.set("position_cycle","2 3 6 1 3 9 4 7 8");
										config.set("display_numblock","1");
						}

						/*
							Einstellungen, die der Übersicht halber nicht in der Konfigurationsdatei stehen.
						*/
						private void add_intern_values(){
										config.set("numblock_width","350");

						}

						private bool search_config_file(string conffile){
										var file = File.new_for_path (conffile);
										return file.query_exists(null);
						}

						private int create_conf_file(string conffile){
										var file = File.new_for_path (conffile);


										try{
										//Create a new file with this name
										var file_stream = file.create (FileCreateFlags.NONE);
									  // Test for the existence of file
									  if (! file.query_exists ()) {
											 stdout.printf ("Can't create config file.\n");
											return -1;
										}
									  // Write text data to file 
									  var data_stream = new DataOutputStream (file_stream);
										/*
										data_stream.put_string ("#Show/Hide the window\n");
										data_stream.put_string ("show_shortcut=<Ctrl><Alt>R\n");
										data_stream.put_string ("#Show window on top\n");
										data_stream.put_string ("on_top=1\n");
										*/
										foreach( Gee.Map.Entry<string, string> e in this.config.entries){
											data_stream.put_string ( e.key+" = "+e.value+"\n" );
										}
									 } // Streams 
										catch ( GLib.IOError e){ return -1; }
										catch ( GLib.Error e){ return -1; }

							return 0;
						}

						private int load_config_file(string conffile){

										// A reference to our file
										var file = File.new_for_path (conffile);

										try {
												// Open file for reading and wrap returned FileInputStream into a
												// DataInputStream, so we can read line by line
												var in_stream = new DataInputStream (file.read (null));
												string line;
												string[] split;
												var comment = new Regex("^#.*$");
												var regex = new Regex("(#[^=]*)*[ ]*=[ ]*");

												// Read lines until end of file (null) is reached
												while ((line = in_stream.read_line (null, null)) != null) {
														//stdout.printf ("%s\n", line);
														if( comment.match(line)) continue;
													  split = regex.split(line);
														if(split.length>1){
																//debug(split[0]+" "+split[1]+"\n");
																this.config.set(split[0],split[1]);
														}
												}
														} catch (GLib.IOError e) {
																error ("%s", e.message);
																//return -1;
														} catch (RegexError e) {
																error ("%s", e.message);
																//return -1;
														}catch (GLib.Error e) {
																error ("%s", e.message);
																//return -1;
														}

											return 0;
										}


								}
				}
